#!/usr/bin/env python3

# read json from stdin and pretty print it

import fileinput
import json

with fileinput.input() as finput:
    for line in finput:
        try:
            p = json.loads(line)
        except json.JSONDecodeError:
            print("failed to decode json")
            print(line)

        if p:
            print(json.dumps(p, indent=4))

