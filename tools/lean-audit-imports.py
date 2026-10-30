"""Record the source-level import closure of the pinned Erdos771 module."""
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / 'reproduction/lean-proofs/src/latest'
OUT = ROOT / 'reproduction/import-audit.json'
SOURCE_ROOTS = [SRC]
if '--dependencies' in sys.argv:
    manifest = json.loads((SRC / 'lake-manifest.json').read_text())
    for package in manifest['packages']:
        if package['name'] in {'mathlib', 'batteries', 'Qq', 'aesop', 'proofwidgets',
                                'Cli', 'LeanSearchClient', 'plausible', 'importGraph'}:
            continue
        base = (SRC / '.lake/packages' / package['name']) if package['type'] == 'git' else (SRC / package['dir'])
        if package.get('subDir'):
            base = base / package['subDir']
        SOURCE_ROOTS.append(base)
    OUT = ROOT / 'reproduction/import-audit-with-dependencies.json'

def strip_comments(text):
    result = []
    depth = 0
    i = 0
    while i < len(text):
        if text[i:i+2] == '/-':
            depth += 1
            result.append('  ')
            i += 2
        elif depth and text[i:i+2] == '-/':
            depth -= 1
            result.append('  ')
            i += 2
        elif not depth and text[i:i+2] == '--':
            end = text.find('\n', i)
            if end == -1:
                break
            result.append(' ' * (end-i))
            i = end
        else:
            result.append('\n' if text[i] == '\n' else (' ' if depth else text[i]))
            i += 1
    return ''.join(result)

pending = ['ErdosProblems.Erdos771']
modules = {}
external = set()
while pending:
    module = pending.pop()
    if module in modules or module in external:
        continue
    path = next((base / (module.replace('.', '/') + '.lean') for base in SOURCE_ROOTS
                 if (base / (module.replace('.', '/') + '.lean')).exists()), None)
    if path is None:
        external.add(module)
        continue
    content = path.read_bytes()
    clean = strip_comments(content.decode('utf-8-sig'))
    imports = []
    for match in re.finditer(r'^\s*(?:public\s+)?import\s+([^\n]+)', clean, re.M):
        imports.extend(match.group(1).split())
    flags = []
    for match in re.finditer(r'\b(sorry|admit|axiom|unsafe|native_decide|implemented_by|extern)\b', clean):
        flags.append({'line': clean[:match.start()].count('\n')+1, 'token': match.group()})
    modules[module] = {
        'path': str(path.relative_to(ROOT)),
        'sha256': hashlib.sha256(content).hexdigest(),
        'line_count': len(content.splitlines()),
        'imports': imports,
        'flags': flags,
    }
    pending.extend(imports)

report = {'root_module': 'ErdosProblems.Erdos771', 'source_root': str(SRC),
          'modules': dict(sorted(modules.items())), 'external_imports': sorted(external)}
OUT.write_text(json.dumps(report, indent=2) + '\n', encoding='utf-8')
print(f'Local modules: {len(modules)}; total lines: {sum(x["line_count"] for x in modules.values())}')
print('External imports:', ', '.join(sorted(external)))
for module, details in sorted(modules.items()):
    if details['flags']:
        print(module, details['flags'])
print('Report:', OUT)
