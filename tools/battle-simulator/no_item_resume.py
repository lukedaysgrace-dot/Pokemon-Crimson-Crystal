"""Resume the pinned audit with retries for transient Windows rename locks.

This launcher leaves the audit driver, battle policy, and scenario hashes intact.
"""
import os
from pathlib import Path
import runpy
import sys
import time


def main():
    original_replace = os.replace

    def replace_with_retry(source, destination, *args, **kwargs):
        for attempt in range(61):
            try:
                return original_replace(source, destination, *args, **kwargs)
            except PermissionError:
                if attempt == 60:
                    raise
                time.sleep(0.5)

    os.replace = replace_with_retry
    driver = Path(__file__).with_name("no_item_audit.py")
    sys.argv[0] = str(driver)
    runpy.run_path(str(driver), run_name="__main__")


if __name__ == "__main__":
    main()
