#!/usr/bin/env python

import sys

for module in sys.argv[1:]:
    print(f"{module}: {__import__(module).__version__}")
