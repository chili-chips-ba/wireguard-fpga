import re
from typing import TYPE_CHECKING, Optional

from . import helpers
from ..node import Node, AddressableNode

if TYPE_CHECKING:
    from markdown import Markdown

def rdlfc_to_html(text: str, node: Optional[Node]=None, md: Optional['Markdown']=None, is_desc: bool=True) -> str:
    """
    Convert an RDLFormatCode string to HTML
    """

    # --------------------------------------------------------------------------
    # Remove any common indentation
    # --------------------------------------------------------------------------
    text = helpers.dedent_text(text)

    # --------------------------------------------------------------------------
    # Parse and replace RDLFormatCode Tags
    # --------------------------------------------------------------------------
    token_spec = [
        ('b', r'\[b\]'),
        ('xb', r'\[/b\]'),
        ('i', r'\[i\]'),
        ('xi', r'\[/i\]'),
        ('u', r'\[u\]'),
        ('xu', r'\[/u\]'),
        ('color', r'\[color=[^\]]+\]'),
        ('xcolor', r'\[/color\]'),
        ('size', r'\[size=[^\]]+\]'),
        ('xsize', r'\[/size\]'),
        ('plainurl', r'\[url\].*?\[/url\]'),
        ('url', r'\[url=[^\]]+\]'),
        ('xurl', r'\[/url\]'),
        ('email', r'\[email\].*?\[/email\]'),
        ('img', r'\[img\].*?\[/img\]'),
        ('code', r'\[code\].*?\[/code\]'),
        ('list', r'\[list(?:=[^\]]+)?\]'),
        ('bullet', r'\[\*\]'),
        ('xlist', r'\[/list\]'),
        ('quote', r'\[quote\]'),
        ('xquote', r'\[/quote\]'),
        ('br', r'\[br\]'),
        ('lb', r'\[lb\]'),
        ('rb', r'\[rb\]'),
        ('p', r'\[p\]'),
        ('xp', r'\[/p\]'),
        ('sp', r'\[sp\]'),
        ('index', r'\[index\]'),
        ('index_parent', r'\[index_parent\]'),
        ('name', r'\[name\]'),
        ('instname', r'\[instname\]'),
    ]

    if is_desc:
        tok_regex = '|'.join(f"(?P<{pair[0]}>{pair[1]})" for pair in token_spec)
    else:
        # filter out tags that are not to be interpreted in 'name' properties
        skipset = {'img', 'list', 'bullet', 'xlist', 'br', 'p', 'xp', 'index', 'index_parent', 'name'}
        tok_regex = '|'.join(f"(?P<{pair[0]}>{pair[1]})" for pair in token_spec if pair[0] not in skipset)

    pos = 0
    text_segs = []
    is_first_bullet = []
    list_end_tag = []
    for m in re.finditer(tok_regex, text, re.DOTALL):
        start = m.start()
        end = m.end()

        # Emit prior text
        if start != pos:
            text_segs.append(text[pos:start])
        pos = end

        if m.lastgroup == 'b':
            text_segs.append("<b>")
        elif m.lastgroup == 'xb':
            text_segs.append("</b>")
        elif m.lastgroup == 'i':
            text_segs.append("<i>")
        elif m.lastgroup == 'xi':
            text_segs.append("</i>")
        elif m.lastgroup == 'u':
            text_segs.append("<u>")
        elif m.lastgroup == 'xu':
            text_segs.append("</u>")
        elif m.lastgroup == 'color':
            m2 = re.match(r'\[color=([^\]]+)\]', m.group(0))
            assert m2 is not None
            text_segs.append('<span style="color:%s">' % m2.group(1))
        elif m.lastgroup == 'xcolor':
            text_segs.append('</span>')
        elif m.lastgroup == 'size':
            m2 = re.match(r'\[size=([^\]]+)\]', m.group(0))
            assert m2 is not None
            text_segs.append('<span style="font-size:%s">' % m2.group(1))
        elif m.lastgroup == 'xsize':
            text_segs.append('</span>')
        elif m.lastgroup == 'plainurl':
            m2 = re.match(r'\[url\](.*?)\[/url\]', m.group(0), re.DOTALL)
            assert m2 is not None
            text_segs.append('<a href="%s">%s</a>' % (m2.group(1).strip(), m2.group(1).strip()))
        elif m.lastgroup == 'url':
            m2 = re.match(r'\[url=([^\]]+)\]', m.group(0))
            assert m2 is not None
            text_segs.append('<a href="%s">' % m2.group(1).strip())
        elif m.lastgroup == 'xurl':
            text_segs.append('</a>')
        elif m.lastgroup == 'email':
            m2 = re.match(r'\[email\](.*?)\[/email\]', m.group(0), re.DOTALL)
            assert m2 is not None
            text_segs.append('<a href="mailto:%s">%s</a>' % (m2.group(1).strip(), m2.group(1).strip()))
        elif m.lastgroup == 'img':
            m2 = re.match(r'\[img\](.*?)\[/img\]', m.group(0), re.DOTALL)
            assert m2 is not None
            text_segs.append('<img src="%s">' % m2.group(1))
        elif m.lastgroup == 'code':
            m2 = re.match(r'\[code\](.*?)\s*\[/code\]', m.group(0), re.DOTALL)
            assert m2 is not None
            text_segs.append('<code>%s</code>' % m2.group(1))

        elif m.lastgroup == 'list':
            # List start tag
            m2 = re.match(r'\[list(?:=([^\]]+))?\]', m.group(0))
            assert m2 is not None
            ltype = m2.group(1)
            if ltype is None:
                text_segs.append('<ul>')
                is_first_bullet.append(True)
                list_end_tag.append('</ul>')
            elif ltype.strip() in ("1", "A", "a", "I", "i"):
                text_segs.append('<ol type="%s">' % ltype.strip())
                is_first_bullet.append(True)
                list_end_tag.append('</ol>')
            else:
                # Bad type. re-emit erroneous list tag
                text_segs.append(m.group(0))

        elif m.lastgroup == 'bullet':
            if len(is_first_bullet) == 0: #pylint: disable=len-as-condition
                # Not inside a list tag. Re-emit erroneous tag
                text_segs.append("\\[\\*\\]")
            else:
                if not is_first_bullet[-1]:
                    text_segs.append("</li>")
                is_first_bullet[-1] = False
                text_segs.append("<li>")

        elif m.lastgroup == 'xlist':
            if len(list_end_tag) == 0: #pylint: disable=len-as-condition
                # Not inside a list tag. Re-emit erroneous tag
                text_segs.append(m.group(0))
            else:
                if not is_first_bullet[-1]:
                    text_segs.append("</li>")
                text_segs.append(list_end_tag[-1])
                is_first_bullet.pop()
                list_end_tag.pop()

        elif m.lastgroup == 'quote':
            text_segs.append('"')
        elif m.lastgroup == 'xquote':
            text_segs.append('"')
        elif m.lastgroup == 'br':
            text_segs.append("<br>")
        elif m.lastgroup == 'lb':
            text_segs.append("[")
        elif m.lastgroup == 'rb':
            text_segs.append("]")
        elif m.lastgroup == 'p':
            text_segs.append("\n\n<p>")
        elif m.lastgroup == 'xp':
            text_segs.append("</p>")
        elif m.lastgroup == 'sp':
            text_segs.append("&nbsp;")
        elif m.lastgroup == 'index':
            if (node is not None) and isinstance(node, AddressableNode) and node.array_dimensions:
                subscripts = []
                if node.current_idx is None:
                    # Index is not known. Use range
                    for dim in node.array_dimensions:
                        subscripts.append("[0:%d]" % (dim-1))
                else:
                    # Index is known
                    for idx in node.current_idx:
                        subscripts.append("[%d]" % idx)
                range_str = "".join(subscripts)
                text_segs.append("<span class='rdlfc-index'>%s</span>" % range_str)
            else:
                text_segs.append(m.group(0))
        elif m.lastgroup == 'index_parent':
            if (node is not None) and (node.parent is not None) and isinstance(node.parent, AddressableNode) and node.parent.array_dimensions:
                subscripts = []
                if node.parent.current_idx is None:
                    # Index is not known. Use range
                    for dim in node.parent.array_dimensions:
                        subscripts.append("[0:%d]" % (dim-1))
                else:
                    # Index is known
                    for idx in node.parent.current_idx:
                        subscripts.append("[%d]" % idx)
                range_str = "".join(subscripts)
                text_segs.append("<span class='rdlfc-index_parent'>%s</span>" % range_str)
            else:
                text_segs.append(m.group(0))
        elif m.lastgroup == 'name':
            if node is not None:
                text_segs.append(node.get_property('name'))
            else:
                text_segs.append(m.group(0))
        elif m.lastgroup == 'instname':
            if node is not None:
                text_segs.append(node.inst_name)
            else:
                text_segs.append(m.group(0))

    # Emit trailing text
    text_segs.append(text[pos:])

    text_out = "".join(text_segs)

    #---------------------------------------------------------------------------
    # Pass through markdown processor
    #---------------------------------------------------------------------------
    if is_desc:
        if md is None:
            # Lazy import markdown
            import markdown # pylint: disable=import-outside-toplevel
            md = markdown.Markdown()
        text_out = md.reset().convert(text_out)

    return text_out
