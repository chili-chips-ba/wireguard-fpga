'''
Math extension for Python-Markdown
==================================

Adds support for displaying math formulas using
[MathJax](http://www.mathjax.org/).

Author: 2015-2025, Dmitry Shachnev <mitya57@gmail.com>.
'''

from xml.etree.ElementTree import Element
from markdown.inlinepatterns import InlineProcessor
from markdown.extensions import Extension
from markdown.preprocessors import Preprocessor
from markdown.util import AtomicString


def _wrap_node(node, preview_text, wrapper_tag):
    preview = Element('span', {'class': 'MathJax_Preview'})
    preview.text = AtomicString(preview_text)
    wrapper = Element(wrapper_tag)
    wrapper.extend([preview, node])
    return wrapper


class InlineMathPattern(InlineProcessor):
    def handleMatch(self, m, data):
        node = Element('script')
        node.set('type', self._content_type)
        node.text = AtomicString(m.group(2))
        if self._add_preview:
            node = _wrap_node(node, m.group(0), 'span')
        return node, m.start(0), m.end(0)


class DisplayMathPattern(InlineProcessor):
    def handleMatch(self, m, data):
        node = Element('script')
        node.set('type', '%s; mode=display' % self._content_type)
        if '\\begin' in m.group(1):
            node.text = AtomicString(m.group(0))
        else:
            node.text = AtomicString(m.group(2))
        if self._add_preview:
            node = _wrap_node(node, m.group(0), 'div')
        return node, m.start(0), m.end(0)


class GitLabPreprocessor(Preprocessor):
    """
    Preprocessor for GitLab-style standalone syntax:

    ```math
    math goes here
    ```
    """

    def run(self, lines):
        inside_math_block = False
        math_block_start = None
        math_blocks = []

        for line_number, line in enumerate(lines):
            if line.strip() == '```math' and not inside_math_block:
                math_block_start = line_number
                inside_math_block = True
            if line.strip() == '```' and inside_math_block:
                math_blocks.append((math_block_start, line_number))
                inside_math_block = False

        for math_block_start, math_block_end in reversed(math_blocks):
            math_lines = lines[math_block_start + 1:math_block_end]
            math_content = '\n'.join(math_lines)
            html = '<script type="%s; mode=display">\n%s\n</script>\n'
            html %= (self._content_type, math_content)
            placeholder = self.md.htmlStash.store(html)
            lines[math_block_start:math_block_end + 1] = [placeholder]
        return lines


class MathExtension(Extension):
    def __init__(self, *args, **kwargs):
        self.config = {
            'enable_dollar_delimiter':
                [False, 'Enable single-dollar delimiter'],
            'add_preview': [False, 'Add a preview node before each math node'],
            'use_asciimath':
                [False, 'Use AsciiMath syntax instead of TeX syntax'],
            'use_gitlab_delimiters':
                [False, 'Use GitLab-style $`...`$ delimiters'],
        }
        super().__init__(*args, **kwargs)

    def extendMarkdown(self, md):
        add_preview = self.getConfig('add_preview')
        use_asciimath = self.getConfig('use_asciimath')
        use_gitlab_delimiters = self.getConfig('use_gitlab_delimiters')
        content_type = 'math/asciimath' if use_asciimath else 'math/tex'

        inlinemathpatterns = (
            InlineMathPattern(r'(?<!\\|\$)(\$)([^\$]+)(\$)'),    #  $...$
            InlineMathPattern(r'(?<!\\)(\\\()(.+?)(\\\))')       # \(...\)
        )
        mathpatterns = (
            DisplayMathPattern(r'(?<!\\)(\$\$)([^\$]+)(\$\$)'),  # $$...$$
            DisplayMathPattern(r'(?<!\\)(\\\[)(.+?)(\\\])'),     # \[...\]
            DisplayMathPattern(                            # \begin...\end
                r'(?<!\\)(\\begin{([a-z]+?\*?)})(.+?)(\\end{\2})')
        )
        if not self.getConfig('enable_dollar_delimiter'):
            inlinemathpatterns = inlinemathpatterns[1:]
        if use_asciimath:
            mathpatterns = mathpatterns[:-1]  # \begin...\end is TeX only
        if use_gitlab_delimiters:
            # https://gitlab.com/gitlab-org/gitlab/blob/master/doc/user/markdown.md#math
            inlinemathpatterns = (
                InlineMathPattern(r'(?<!\\)(\$`)([^`]+)(`\$)'),  # $`...`$
            )
            mathpatterns = ()
            preprocessor = GitLabPreprocessor(md)
            preprocessor._content_type = content_type
            # we should have higher priority than 'fenced_code_block' which
            # has 25
            md.preprocessors.register(preprocessor, 'math-gitlab', 27)

        for i, pattern in enumerate(mathpatterns):
            pattern._add_preview = add_preview
            pattern._content_type = content_type
            # we should have higher priority than 'escape' which has 180
            # also begin/end pattern should have lower priority than all others
            priority = 184 if i == 2 else 185
            md.inlinePatterns.register(pattern, 'math-%d' % i, priority)
        for i, pattern in enumerate(inlinemathpatterns):
            pattern._add_preview = add_preview
            pattern._content_type = content_type
            # to use gitlab delimiters, we should have higher priority than
            # 'backtick' which has 190
            priority = 195 if use_gitlab_delimiters else 185
            md.inlinePatterns.register(pattern, 'math-inline-%d' % i, priority)
        if self.getConfig('enable_dollar_delimiter'):
            md.ESCAPED_CHARS.append('$')


def makeExtension(*args, **kwargs):
    return MathExtension(*args, **kwargs)
