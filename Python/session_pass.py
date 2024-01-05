#!/usr/bin/env python3

import base64
import getpass
import json
import sys

def session_password():
    try:
        p = getpass.getpass(prompt="Enter password: ")
        return p
    except KeyboardInterrupt:
        print("Keyboard Interrupt detected\nQuitting")
        sys.exit()
    except Exception as err:
        print(f"Error encountered: {err}\nQuitting")
        sys.exit()
