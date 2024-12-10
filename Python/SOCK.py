#!/usr/bin/env python3

import argparse
import socket
import subprocess
import sys
import json

####################
## HELPER BLOCK
####################

def string_to_bytes(m: str):
    """
    helper
    """
    if isinstance(m, str):
        return m.encode("utf-8")
    elif isinstance(m, bytes):
        return m
    else:
        sys.exit("Error converting str to bytes. Unexpected type provided")

def bytes_to_string(b: bytes):
    """
    """
    if isinstance(b, bytes):
        return b.decode("utf-8")
    elif isinstance(b, str):
        return b
    else:
        sys.exit("Error converting bytes to string. Unexpected type provided")


def socket_ops(host: str, port: int, message: str, quiet: bool=True) -> str:
    """
    """
    bmsg = string_to_bytes(m=message)
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        try:
            s.connect((host, port))
            print("Attempt message send")
            s.sendall(bmsg)

            response = s.recv(2048)
            out_response = bytes_to_string(b=response)

        except ConnectionRefusedError:
            sys.exit("Connection refused error encountered")
    
    return out_response


def query_mailq(host: str, port: int=9002, message: str):
    if isinstance(host, str):
        r = socket_ops(host=host, port=port, message=message)
    
    elif isinstance(host, list):
        r = []
        for x in host:
            e = socket_ops(host=host, port=port, message=message)
            r.append(e)
    else:
        sys.exit(f"Unexpected input. {host=} is {type(host)}"
    return r


if __name__ == "__main__":

    parser = argparse.ArgumentParser(prog='posttool')
    parser.add_argument("host", help="Host to query")
    parser.add_argument("-m", "--message", help="Alter send message content", type=str,)
    parser.add_argument("-p", "--port", help="Alter target host port", type=int, default=51324)
    parser.add_argument("-q", "--quiet", help="Suppress output", action="store_true", default=False)

    args = parser.parse_args()

    mailq = query_mailq(host=args.host, port=args.port, message=args.message)
