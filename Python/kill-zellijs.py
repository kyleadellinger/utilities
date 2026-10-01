#!/usr/bin/env python3

import argparse
import shlex
import subprocess
import sys

def run_cmd(cmd: str, *, timeout: int = 10) -> subprocess.CompletedProcess|None:
    _cmd = shlex.split(cmd)
    try:
        r = subprocess.run(_cmd, timeout=timeout, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    except TimeoutError:
        print(f"Error: Timeout running '{cmd}'")
        return
    return r

def find_and_kill_zellijs_processes(verbose: bool = False) -> None:
    raw = run_cmd("pgrep --list-full zellij")
    decoded = raw.stdout.decode("utf-8").splitlines()
    for d in decoded:
        if "--server" in d:
            _d = d.split(" ")

            if verbose:
                print(_d[0], _d[-2], _d[-1])

            x = run_cmd(f"kill -9 {_d[0]}")
            if verbose:
                print(f"Killed: '{x.stdout.decode('utf-8')}'")
    return

def args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("-v", "--verbose", help="Include information lines", action="store_true", default=False)

    return parser.parse_args()

def main():
    _args = args()
    find_and_kill_zellijs_processes(verbose=_args.verbose)
    return


if __name__ == "__main__":
    main()

