#!/usr/bin/env python3

import base64

def convert_to_base64(stringthing):
    if isinstance(stringthing, str):
        return base64.b64encode(stringthing.encode()).decode()
    else:
        print("input string.")
    
def convert_from_base64(stringthing):
    if isinstance(stringthing, str):
        return base64.b64decode(stringthing).decode()
    else:
        print("input string.")
