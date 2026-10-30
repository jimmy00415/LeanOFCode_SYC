"""Apply the project's exact git-blob patches, avoiding Windows CRLF conversion."""
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT / 'reproduction/lean-proofs'
PROJECT = REPO / 'src/latest'
OUT = ROOT / 'reproduction/patches'
OUT.mkdir(exist_ok=True)
PAIRS = [
    ('BoundedGaps', 'formalpantheon-v4.33.0.patch'),
    ('BoundedGaps', 'formalpantheon-v4.33.0-s2.patch'),
    ('BoundedGaps', 'boundedgaps-linter-v4.33.0.patch'),
    ('AINTLIB', 'aintlib-v4.33.0.patch'),
    ('AINTLIB', 'hasseweil-linter-v4.33.0.patch'),
    ('AINTLIB', 'chebotarev-linter-v4.33.0.patch'),
    ('AINTLIB', 'dedekind-flt-linter-v4.33.0.patch'),
    ('leancert', 'leancert-linter-v4.33.0.patch'),
    ('Waring', 'waring-linter-v4.33.0.patch'),
]
for package, name in PAIRS:
    raw = subprocess.check_output(['git', 'show', f'HEAD:src/latest/patches/{name}'], cwd=REPO)
    patch = OUT / name
    patch.write_bytes(raw)
    target = PROJECT / '.lake/packages' / package
    print(f'Applying exact blob {name} to {package}; bytes={len(raw)}, CRLF={raw.count(bytes([13,10]))}', flush=True)
    subprocess.run(['git', 'apply', '--check', str(patch)], cwd=target, check=True)
    subprocess.run(['git', 'apply', str(patch)], cwd=target, check=True)
