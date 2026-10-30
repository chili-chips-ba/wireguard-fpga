# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
# SPDX-License-Identifier: BSD-3-Clause
"""Published defaults and local successful builds; no synthesis or HDL imports."""

import datetime
import fcntl
import hashlib
import json
import os
from pathlib import Path
import shutil


def read_json(path, default=None):
    try:
        return json.loads(Path(path).read_text())
    except (FileNotFoundError, json.JSONDecodeError):
        return default


def write_json(path, value):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(path.name + '.' + str(os.getpid()) + '.tmp')
    temporary.write_text(json.dumps(value, indent=2) + '\n')
    temporary.replace(path)


def profile_from_record(record):
    c = record['config']
    return dict(design='shared', implementation=c['poly1305']['implementation'],
                data_bitwidth=c.get('data_bitwidth', 128 * c.get('poly1305_blocks_per_cycle', 1)),
                multiplier=c['poly1305_mult_impl'], compute=c['poly1305_compute_impl'],
                sharing=c['sharing'], target_mhz=int(c['target_mhz']),
                prologue_cap=c.get('poly1305_prologue_max_latency') or 64,
                epilogue_cap=c.get('poly1305_epilogue_max_latency') or 64)


def publish_default(here, record):
    """Called only with the validated record being published to the README."""
    if not record.get('validation', {}).get('passed') or record['config'].get('comb'):
        raise ValueError('Only a validated hardware measurement can become the default')
    here = Path(here).resolve()
    directory = Path(record['label'])
    if not directory.is_absolute():
        directory = here / 'measurements' / directory
    directory = directory.resolve()
    # Keep the default reproducible from the published archive, not scratch state.
    directory.relative_to(here / 'measurements')
    if not (directory / 'results.json').is_file():
        raise ValueError('Default measurement archive is missing: ' + str(directory))
    hints = sorted(directory.glob('*hint*.json'))
    if not hints and directory.name == 'default':
        hints = sorted(directory.parent.glob('*hint*.json'))
    if not hints:
        previous = read_json(here / 'default_build.json', {})
        hints = [here / p for p in previous.get('latency_hints', [])]
    write_json(here / 'default_build.json', dict(
        schema_version=1, measurement=os.path.relpath(directory, here),
        profile=profile_from_record(record),
        latency_hints=[os.path.relpath(p, here) for p in hints if p.is_file()]))


def compiler_path():
    executable = os.environ.get('PYPELINEC') or 'pypelinec'
    return str(Path(shutil.which(executable) or executable).resolve())


def compiler_fingerprint(executable):
    executable = Path(executable)
    if not executable.is_file():
        return None
    root = executable.parent.parent
    paths = {executable}
    for directory in ('src', 'include'):
        paths.update(p for p in (root / directory).rglob('*.py') if 'tests' not in p.parts)
    digest = hashlib.sha256()
    for path in sorted(paths):
        digest.update(str(path.relative_to(root)).encode())
        digest.update(path.read_bytes())
    return digest.hexdigest()


def registry(here):
    return Path(here) / 'generated-files' / 'build-state.json'


def successful_build(here, out_dir, profile, syn_cache, *, compiler=None, completed_utc=None):
    """Register only after the build and direction-latency checks succeeded."""
    here = Path(here).resolve()
    out_dir = Path(out_dir).resolve()
    metadata = read_json(out_dir / 'built_hardware.json')
    if not metadata or metadata.get('native_sim_problems'):
        return
    compiler = compiler or compiler_path()
    entry = dict(out_dir=str(out_dir), profile=profile,
                 syn_cache='none' if syn_cache == 'none' else str(Path(syn_cache).resolve()),
                 compiler=compiler, compiler_fingerprint=compiler_fingerprint(compiler),
                 completed_utc=completed_utc or datetime.datetime.now(datetime.timezone.utc).isoformat())
    path = registry(here)
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.with_suffix('.lock').open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        data = read_json(path, {'schema_version': 1, 'builds': []})
        data['builds'] = [b for b in data['builds'] if b['out_dir'] != entry['out_dir']] + [entry]
        write_json(path, data)


def select_build_state(here, args, profile, published):
    """Explicit flags win; otherwise carry compatible successful evidence forward."""
    here = Path(here).resolve()
    builds = read_json(registry(here), {}).get('builds', [])
    compatible = [b for b in builds if
                  all(b['profile'].get(k) == profile.get(k) for k in
                      ('implementation', 'data_bitwidth', 'multiplier', 'compute', 'target_mhz'))
                  and (Path(b['out_dir']) / 'built_hardware.json').is_file()]
    compatible.sort(key=lambda b: (b['profile'] == profile, b['completed_utc']), reverse=True)
    if args.syn_cache is None:
        cached = next((b for b in compatible if b['syn_cache'] != 'none' and Path(b['syn_cache']).is_dir()), None)
        args.syn_cache = cached['syn_cache'] if cached else str(here / 'generated-files' / 'syn_cache')
    if not args.latency_hints and all(profile.get(k) == published['profile'].get(k) for k in
                                     ('implementation', 'data_bitwidth', 'multiplier')):
        args.latency_hints = [str(here / p) for p in published.get('latency_hints', [])]
    if not args.out_dir:
        previous = next((b for b in compatible if b['profile'] == profile
                         and b['compiler'] == compiler_path()
                         and read_json(Path(b['out_dir']) / 'built_hardware.json', {}).get('top')
                         == str(here / 'src' / 'chacha20poly1305.py')), None)
        if previous:
            args.out_dir = previous['out_dir']
            if hasattr(args, 'continue_build'):
                args.continue_build = True


def hardware_reuse_error(here, out_dir, profile):
    """Preflight before auto reuse; the compiler also performs its own checks."""
    here = Path(here).resolve()
    built = read_json(Path(out_dir) / 'built_hardware.json')
    if not built:
        return 'no completed hardware build'
    if built.get('top') != str(here / 'src' / 'chacha20poly1305.py'):
        return 'hardware belongs to another source checkout'
    if built.get('native_sim_problems'):
        return 'hardware cannot be replayed by the native simulator'
    previous = next((b for b in read_json(registry(here), {}).get('builds', [])
                     if b['out_dir'] == str(Path(out_dir).resolve())), None)
    if previous and (previous['compiler'] != compiler_path() or
                     previous.get('compiler_fingerprint') != compiler_fingerprint(compiler_path())):
        return 'hardware compiler provenance changed'
    p = built.get('design_params', {})
    expected = dict(DESIGN=profile['design'], DATA_BITWIDTH=profile['data_bitwidth'],
                    POLY1305_IMPL=profile['implementation'], POLY1305_MULT_IMPL=profile['multiplier'],
                    POLY1305_COMPUTE_IMPL=profile['compute'], TARGET_MHZ=profile['target_mhz'],
                    POLY1305_PROLOGUE_MAX_LATENCY=profile['prologue_cap'],
                    POLY1305_EPILOGUE_MAX_LATENCY=profile['epilogue_cap'])
    sharing = profile['sharing']
    expected['SHARE'] = ('both' if sharing['poly1305'] else 'chacha20') if sharing['chacha20'] else ('poly1305' if sharing['poly1305'] else 'none')
    for key, value in expected.items():
        if p.get(key, 64 if key.endswith('_MAX_LATENCY') else None) != value:
            return 'hardware profile differs: ' + key
    if not built.get('sources'):
        return 'hardware source provenance is missing'
    for path, digest in built['sources'].items():
        try:
            if hashlib.sha256(Path(path).read_bytes()).hexdigest() == digest:
                continue
        except OSError:
            pass
        return 'hardware source changed: ' + path
    return None


def selftest():
    """Exercise stale replay rejection, cache carry-forward and publication."""
    import tempfile
    from types import SimpleNamespace

    with tempfile.TemporaryDirectory(prefix='wg-build-state-') as temporary:
        here = Path(temporary)
        (here / 'src').mkdir()
        source = here / 'src' / 'chacha20poly1305.py'
        source.write_text('hardware version 1\n')
        out = here / 'generated-files' / 'hardware'
        cache = here / 'generated-files' / 'warm-store'
        cache.mkdir(parents=True)
        profile = dict(design='shared', implementation='pipelined', data_bitwidth=256,
                       multiplier='inferred_body', compute='fsm', target_mhz=80,
                       sharing=dict(chacha20=True, poly1305=False), prologue_cap=44, epilogue_cap=45)
        built = dict(top=str(source), native_sim_problems=[],
                     sources={str(source): hashlib.sha256(source.read_bytes()).hexdigest()},
                     design_params=dict(DESIGN='shared', DATA_BITWIDTH=256,
                                        POLY1305_IMPL='pipelined', POLY1305_MULT_IMPL='inferred_body',
                                        POLY1305_COMPUTE_IMPL='fsm', TARGET_MHZ=80, SHARE='chacha20',
                                        POLY1305_PROLOGUE_MAX_LATENCY=44, POLY1305_EPILOGUE_MAX_LATENCY=45))
        write_json(out / 'built_hardware.json', built)
        assert hardware_reuse_error(here, out, profile) is None
        source.write_text('hardware version 2\n')
        assert 'source changed' in hardware_reuse_error(here, out, profile)
        source.write_text('hardware version 1\n')
        assert 'profile differs' in hardware_reuse_error(here, out, dict(profile, prologue_cap=64))
        assert 'another source checkout' in hardware_reuse_error(here / 'other', out, profile)
        successful_build(here, out, profile, str(cache))
        published = dict(profile=profile, latency_hints=[])
        args = SimpleNamespace(syn_cache=None, out_dir=None, latency_hints=[], continue_build=False)
        select_build_state(here, args, profile, published)
        assert args.syn_cache == str(cache) and args.out_dir == str(out) and args.continue_build
        explicit = SimpleNamespace(syn_cache='none', out_dir='chosen', latency_hints=['chosen.json'])
        select_build_state(here, explicit, profile, published)
        assert (explicit.syn_cache, explicit.out_dir, explicit.latency_hints) == ('none', 'chosen', ['chosen.json'])
        # Nearby caps may reuse the warm store, but must not replay that hardware.
        other = SimpleNamespace(syn_cache=None, out_dir=None, latency_hints=[])
        select_build_state(here, other, dict(profile, prologue_cap=64), published)
        assert other.syn_cache == str(cache) and other.out_dir is None
        record = dict(label='accepted', validation=dict(passed=True), config=dict(
            poly1305=dict(implementation='pipelined'), data_bitwidth=256,
            poly1305_mult_impl='inferred_body', poly1305_compute_impl='fsm',
            sharing=profile['sharing'], target_mhz=80,
            poly1305_prologue_max_latency=44, poly1305_epilogue_max_latency=45))
        archive = here / 'measurements' / 'accepted'
        write_json(archive / 'results.json', record)
        publish_default(here, record)
        before = (here / 'default_build.json').read_bytes()
        assert read_json(here / 'default_build.json')['profile'] == profile
        record['validation']['passed'] = False
        try:
            publish_default(here, record)
        except ValueError:
            pass
        else:
            raise AssertionError('Unqualified result became the default')
        assert (here / 'default_build.json').read_bytes() == before
    print('build state selftest: PASS (stale replay, explicit overrides, cache reuse, publication)')
