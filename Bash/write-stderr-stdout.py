#!/usr/bin/env python3

import sys

print("This is stdout", file=sys.stdout)
print("This is stderr", file=sys.stderr)

# python write-stderr-stdout.py > stdout   # writes "This is stdout" to file "stdout" and prints "This is stderr" to screen
# python write-stderr-stdout.py &> outfile # redirects both stderr and stdout to outfile
# python write-stderr-stdout.py 2> stderr  # sends stderr to file and stdout prints on screen
