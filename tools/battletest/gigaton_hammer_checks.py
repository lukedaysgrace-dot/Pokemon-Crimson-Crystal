#!/usr/bin/env python3
"""Check the current creative Gigaton Hammer slam on both battle sides."""
import sys
from creative_animation_checks import main

if __name__ == '__main__':
    sys.argv.extend(['--moves', 'GIGA_HAMMER'])
    main()
