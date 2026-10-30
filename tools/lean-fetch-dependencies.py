"""Fetch exactly the dependency commits in the pinned Lake manifest; run no Lake hooks."""
import concurrent.futures
import json
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PROJECT = ROOT / 'reproduction/lean-proofs/src/latest'
MANIFEST = json.loads((PROJECT / 'lake-manifest.json').read_text())
PACKAGES = PROJECT / '.lake/packages'
PACKAGES.mkdir(parents=True, exist_ok=True)

def fetch(package):
    name = package['name']
    target = PACKAGES / name
    log = ROOT / 'logs' / f'reproduction-fetch-{name}.log'
    with log.open('w', encoding='utf-8') as stream:
        def run(args, cwd):
            stream.write('$ ' + subprocess.list2cmdline(args) + '\n')
            stream.flush()
            result = subprocess.run(args, cwd=cwd, stdout=stream, stderr=subprocess.STDOUT)
            if result.returncode:
                raise RuntimeError(f'{name}: exit {result.returncode}; see {log}')
        target.mkdir(parents=True, exist_ok=True)
        run(['git', 'init'], target)
        run(['git', 'remote', 'add', 'origin', package['url']], target)
        run(['git', 'fetch', '--depth', '1', 'origin', package['rev']], target)
        run(['git', 'checkout', '--detach', 'FETCH_HEAD'], target)
        run(['git', 'rev-parse', 'HEAD'], target)
    return name

with concurrent.futures.ThreadPoolExecutor(max_workers=4) as pool:
    futures = [pool.submit(fetch, p) for p in MANIFEST['packages'] if p['type'] == 'git']
    for future in concurrent.futures.as_completed(futures):
        try:
            print('Fetched', future.result(), flush=True)
        except Exception as exc:
            print('FAILED', exc, flush=True)
