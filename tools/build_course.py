"""Turn the Virtual Begena lesson-plan .docx into assets/course/chapters.json

Usage:  python tools/build_course.py path/to/virtual_begena.docx [output.json]
"""
import json
import re
import sys
from pathlib import Path

from docx import Document
from docx.table import Table
from docx.text.paragraph import Paragraph

W = '{http://schemas.openxmlformats.org/wordprocessingml/2006/main}'
CHAPTER_RE = re.compile(r'^ምዕራፍ\s*(\d+)\s*[—–-]\s*(.+)$')


def rich_text(p):
    """Paragraph text with **bold** markers around bold runs."""
    segs = []
    for r in p.runs:
        if not r.text:
            continue
        bold = bool(r.bold)
        if segs and segs[-1][1] == bold:
            segs[-1][0] += r.text
        else:
            segs.append([r.text, bold])
    out = []
    for text, bold in segs:
        if bold and text.strip():
            lead = text[: len(text) - len(text.lstrip())]
            trail = text[len(text.rstrip()):]
            out.append(f'{lead}**{text.strip()}**{trail}')
        else:
            out.append(text)
    text = re.sub(r'\s+', ' ', ''.join(out)).strip()
    # pull a trailing ")" / ":" / "፡" / "-" into the bold lead-in: **name**)፡- -> **name)፡-**
    return re.sub(r'^\*\*([^*]+)\*\*(\)?[፡:]*-?)', r'**\1\2**', text)


def is_list(el):
    return el.find(f'.//{W}numPr') is not None


def level(el):
    lvl = el.find(f'.//{W}ilvl')
    return int(lvl.get(f'{W}val')) if lvl is not None else 0


def main(src, dst):
    doc = Document(src)
    chapters = []
    chapter = None
    section = None

    def new_section(heading):
        nonlocal section
        section = {'heading': heading, 'blocks': []}
        chapter['sections'].append(section)

    for el in doc.element.body.iterchildren():
        tag = el.tag.split('}')[1]

        if tag == 'tbl':
            if chapter is None:
                continue
            if section is None:
                new_section(None)
            rows = []
            for row in Table(el, doc).rows:
                cells, last = [], None
                for c in row.cells:
                    if c._tc is last:      # merged cell repeats
                        continue
                    last = c._tc
                    cells.append(re.sub(r'\s+', ' ', c.text).strip())
                rows.append(cells)
            section['blocks'].append({'type': 'table', 'rows': rows})
            continue

        if tag != 'p':
            continue
        p = Paragraph(el, doc)
        text = rich_text(p)
        if not text:
            continue
        style = p.style.name
        listed = is_list(el)

        if style == 'Heading 1':
            continue
        m = CHAPTER_RE.match(p.text.strip())
        if style == 'Heading 2' and m:
            chapter = {'number': int(m.group(1)), 'title': m.group(2).strip(), 'sections': []}
            chapters.append(chapter)
            section = None
            continue
        if chapter is None:
            continue

        if style.startswith('Heading') and not listed:
            new_section(re.sub(r'\*\*', '', text))
            continue

        if section is None:
            new_section(None)
        if listed:
            section['blocks'].append({'type': 'li', 'level': level(el), 'text': text})
        else:
            section['blocks'].append({'type': 'p', 'text': text})

    out = Path(dst)
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps({'chapters': chapters}, ensure_ascii=False, indent=1),
                   encoding='utf-8')
    for ch in chapters:
        blocks = [b for s in ch['sections'] for b in s['blocks']]
        words = sum(len(b.get('text', '').split()) for b in blocks)
        print(f"Chapter {ch['number']}: {len(ch['sections'])} sections, "
              f"{len(blocks)} blocks, ~{words} words")
    print('Wrote', out)


if __name__ == '__main__':
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    main(sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else 'assets/course/chapters.json')
