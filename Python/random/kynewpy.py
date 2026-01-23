#!/usr/bin/env python3

import argparse
import os
import re
import subprocess
import sys


## command line tool (script) to create new (python) file with appropriate shebang 

def check_if_file_exists(filename):
    if os.path.isfile(filename):
        print(f"'{filename}' exists. Quitting.")
        sys.exit()
    elif os.path.isdir(filename):
        print(f"'{filename}' appears to be a directory. Quitting.")
        sys.exit()
    else:
        return True
    
def create_file(filename, shebang):
    with open(filename, "w") as new_file:
        new_file.write(f"#!{shebang}")

def extract_from_poetry_env_info_output(pattern, string):
    """
    takes pattern, string as input; pattern can be compiled re obj or raw string;
    string should be string type; returns match string
    """
    matcher = re.search(pattern, string)
    if matcher:
        return matcher.group(1)
    
def poetry_env_info():
    output = subprocess.getoutput("poetry env info")
    if "Poetry could not find a pyproject.toml" in output:
        print("Poetry (pyproject.toml) not detected here. Quitting.")
        sys.exit()
    else:
        return output


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="create new (python) file with appropriate shebang heading.\nDON'T include '#!' in arg")
    parser.add_argument("-n", "--name", help="name of new file to be created")
    
    group = parser.add_mutually_exclusive_group()
    group.add_argument("-p", "--poetry", help="runs 'poetry env info' and extracts executable location", default=False, action="store_true", dest="boolean_t")
    group.add_argument("-e", "--env", help="file path after shebang")

    args = parser.parse_args()

    if args.name and args.env:
        answer = check_if_file_exists(args.name)
        if answer:
            create_file(args.name, args.env)
            print(f"File {args.name} created with {args.env}")
    elif args.name and args.boolean_t:
        answer = check_if_file_exists(args.name)
        if answer:
            poetry = poetry_env_info()
            match_pattern = r"Executable:\s+(\/home\/.*)"
            exe_path = extract_from_poetry_env_info_output(pattern=match_pattern, string=poetry)
            create_file(args.name, exe_path)
            print(f"File {args.name} created with {exe_path}")
    elif args.name:
        print("Only name supplied. Either specify contents after shebang, or use 'poetry' option (in proper location).")
    else:
        print("Name not supplied. Nothing happened.")
