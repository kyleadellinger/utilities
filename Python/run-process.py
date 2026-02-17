#!/usr/bin/env python

import shlex
import subprocess
import sys

# for posterity (mine)
def run_subprocess(cmd, *args, **kwargs):
    """
    Nifty wrapper to run subprocesses.

    (retrieved from people smarter than me,
    for study and thinking purposes.)

    """
    # note to self: add logging things for more fun.
  
    try:
        verbose_print = kwargs.pop("verbose")

    except KeyError:
        verbose_print = False

    def _info_print(s: str = None) -> None:
        if verbose_print:
            print(f"Info: {s}")
        return

    if isinstance(cmd, str):
        _info_print(f"String command received: {cmd}")
        _cmd = shlex.split(cmd)
        _info_print(f"Split: {_cmd}")

    elif isinstance(cmd, list):
        _info_print(f"List command received: {cmd}")
        _cmd = cmd

    else:
        raise SystemExit(
            "Invaild command detected. (might actually be better checked/written in future but here we are)"
        )

    proc = subprocess.run(
        # original:
        # _cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, *args, **kwargs
        _cmd,
        capture_output=True,
        *args,
        **kwargs,
    )
    printable_cmd = " ".join(_cmd)
    if proc.returncode != 0:
        print(
            f"Ran {printable_cmd}; received exit code {proc.returncode}",
            file=sys.stderr,
        )
        print("Message:\n", file=sys.stderr)
        print(f"Stdout: {proc.stdout.decode('utf-8')}", file=sys.stderr)
        print(f"Stderr: {proc.stderr.decode('utf-8')}", file=sys.stderr)
        raise subprocess.CalledProcessError(cmd=cmd, returncode=proc.returncode)

    else:
        _info_print(f"Command completed: exit code {proc.returncode}")
        print({proc.stdout.decode("utf-8")})
    return
