#!/usr/bin/env python3
"""
Very lightweight report collector for the lecture.
It does not assume one exact Genus report formatting.
Use it to gather report filenames and manually enter key numbers in the
student table if your Genus version formats reports differently.
"""
from pathlib import Path
import re, sys

root = Path(sys.argv[1] if len(sys.argv) > 1 else "../results")
for p in sorted(root.rglob("*.rpt")):
    print(p)
