#!/usr/bin/env python3

import argparse
import subprocess

from shutil import which

_GOVC = which("govc")
if not _GOVC:
    raise SystemExit("Error: govc not found in path")

def _run_cmd(cmd: str|list, *, timeout: int = 10) -> subprocess.CompletedProcess:
    """
    """
    if isinstance(cmd, str):
        _cmd = shlex.split(cmd)
    elif isinstance(cmd, list):
        _cmd = cmd
    else:
        raise SystemExit(f"Invalid type provided: '{cmd}' | type: '{type(cmd)}'")

    r = subprocess.run(_cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=timeout)
    if r.returncode != 0:
        print(f"Warning: '{_cmd = }' '{r.returncode = }'")
    return r

def _vm_info(arg_space: argparse.Namespace, vm: str = None, datacenter: str = "dev", *args, govcbin: str = _GOVC):

    _dc_lookup = {
            "dev": "DC3 Manassas, VA",
            "test": "DC3 Manassas, VA",
            "prod1": "DC1 Grand Rapids, MI",
            "prod2": "DC2 Las Vegas, NV",
            }
    if arg_space:
        vm = arg_space.vm
        datacenter = arg_space.env
    else:
        if not vm or not datacenter:
            raise SystemExit("Missing required arguments. Provide a namespace, or individual args")

    try:
        use_dc = _dc_lookup[datacenter.casefold()]
    except KeyError:
        raise SystemExit(f"Error: unknown DC: '{datacenter}'")

    _base = [govcbin, "vm.info", f"-dc={use_dc}"]
    if args:
        for a in args:
            _base.append(a)
    _base.append(vm.strip())
    r = _run_cmd(_base)
    print(r.stdout.decode("utf-8"))

    return

def main():
    parser = argparse.ArgumentParser(prog='py-govc')
    parser.add_argument("env", help="Datacenter", choices=("dev", "test", "prod1", "prod2"))

    subparsers = parser.add_subparsers(help="subcommand help")

    # vm.info wrapper
    info_parser = subparsers.add_parser("info", help="vm.info wrapper")
    info_parser.add_argument("vm", help="FQDN of VM")
    info_parser.add_argument("-j", "--json", help="JSON output", action="store_true", default=False)
    info_parser.add_argument("-e", "--extra", help="Show extra config", action="store_true", default=False)
    info_parser.add_argument("-r", "--resource", help="Show resource summary", action="store_true", default=False)
    info_parser.set_defaults(func=_vm_info)

    args = parser.parse_args()
    args.func(args)

if __name__ == "__main__":
    main()

