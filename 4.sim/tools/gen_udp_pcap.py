#!/usr/bin/env python3

# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

import argparse, struct, random

MAGIC_NS = 0xA1B23C4D

def be16(x): return struct.pack('>H', x)
def be32(x): return struct.pack('>I', x)

def mac_bytes(s):
    s = s.replace('-',':')
    parts = s.split(':')
    assert len(parts)==6
    return bytes(int(p,16) for p in parts)

def ip_bytes(s):
    parts = s.split('.')
    assert len(parts)==4
    return bytes(int(p) & 0xff for p in parts)

def ipv4_checksum(hdr):
    if len(hdr)%2: hdr += b'\x00'
    s=0
    for i in range(0,len(hdr),2): s += (hdr[i]<<8) | hdr[i+1]
    s = (s & 0xffff) + (s>>16)
    s = (s & 0xffff) + (s>>16)
    return struct.pack('>H', (~s) & 0xffff)

def udp_checksum(src_ip, dst_ip, udp):
    pseudo = src_ip + dst_ip + b'\x00' + b'\x11' + struct.pack('>H', len(udp))
    data = pseudo + udp
    if len(data)%2: data += b'\x00'
    s=0
    for i in range(0,len(data),2): s += (data[i]<<8) | data[i+1]
    s = (s & 0xffff) + (s>>16)
    s = (s & 0xffff) + (s>>16)
    res = (~s) & 0xffff
    if res==0: res=0xffff
    return struct.pack('>H', res)

def build_udp_frame(src_mac, dst_mac, src_ip, dst_ip, sport, dport, payload):
    eth = dst_mac + src_mac + be16(0x0800)
    ver_ihl = bytes([0x45])
    tos= b'\x00'
    tot_len = be16(20+8+len(payload))
    ident = b'\x00\x00'
    flags_frag = b'\x00\x00'
    ttl = b'\x40'
    proto = b'\x11'
    chksum = b'\x00\x00'
    iphdr_wo_csum = ver_ihl+tos+tot_len+ident+flags_frag+ttl+proto+chksum+src_ip+dst_ip
    chksum = ipv4_checksum(iphdr_wo_csum)
    iphdr = ver_ihl+tos+tot_len+ident+flags_frag+ttl+proto+chksum+src_ip+dst_ip
    udphdr = be16(sport)+be16(dport)+be16(8+len(payload))+b'\x00\x00'
    udphdr = udphdr[:-2] + udp_checksum(src_ip, dst_ip, udphdr+payload)
    return eth + iphdr + udphdr + payload

def write_pcap(out_path, frames, interval_ns):
    import os
    os.makedirs(os.path.dirname(out_path) or ".", exist_ok=True)
    with open(out_path,'wb') as f:
        gh = struct.pack('<IHHIIII', MAGIC_NS, 2, 4, 0, 0, 0x00040000, 1)
        f.write(gh)
        t = 0
        for fr in frames:
            sec = t//1_000_000_000
            nsec= t%1_000_000_000
            f.write(struct.pack('<IIII', sec, nsec, len(fr), len(fr)))
            f.write(fr)
            t += interval_ns

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--out', default='./tools/test_udp_rand.pcap')
    ap.add_argument('--frames', type=int, default=5)
    ap.add_argument('--interval-us', type=int, default=1000)
    ap.add_argument('--src-mac', default='D8:9E:F3:88:7E:C3')
    ap.add_argument('--dst-mac', default='90:32:4B:07:0B:D1')
    ap.add_argument('--src-ip',  default='192.168.25.8')
    ap.add_argument('--dst-ip',  default='192.168.152.1')
    ap.add_argument('--sport', type=int, default=40000)
    ap.add_argument('--dport', type=int, default=1025)
    ap.add_argument('--payload', type=int, default=64)
    args = ap.parse_args()

    src_mac = mac_bytes(args.src_mac)
    dst_mac = mac_bytes(args.dst_mac)
    src_ip  = ip_bytes(args.src_ip)
    dst_ip  = ip_bytes(args.dst_ip)
    frames=[]
    for i in range(args.frames):
        pay = bytes((j%256) for j in range(args.payload))
        fr = build_udp_frame(src_mac, dst_mac, src_ip, dst_ip, args.sport+i, args.dport, pay)
        frames.append(fr)
    write_pcap(args.out, frames, args.interval_us*1000)
    print(f"Wrote {len(frames)} frames to {args.out}")

if __name__=='__main__':
    main()
