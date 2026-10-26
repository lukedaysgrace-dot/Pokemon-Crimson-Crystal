"""Verify and package this audit, excluding ROMs, saves and other repo files."""
import subprocess
import sys
import zipfile
from pathlib import Path

HERE=Path(__file__).resolve().parent


def main():
    subprocess.run([sys.executable,'-B',str(HERE/'verify_outputs.py')],check=True)
    target=HERE/'crimson-crystal-exp-audit-2026-10-26.zip'
    files=[p for p in sorted(HERE.iterdir()) if p.is_file() and p.suffix not in {'.zip','.tmp'}]
    with zipfile.ZipFile(target,'w',compression=zipfile.ZIP_DEFLATED,compresslevel=6) as z:
        for p in files:z.write(p,arcname=HERE.name+'/'+p.name)
    with zipfile.ZipFile(target) as z:
        assert z.testzip() is None
        assert len(z.infolist())==len(files)
    print(f'Packaged {len(files)} files, {sum(p.stat().st_size for p in files):,} bytes uncompressed.')
    print(f'{target}: {target.stat().st_size:,} bytes; archive integrity passed.')


if __name__=='__main__':main()
