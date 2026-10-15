#!/usr/bin/env python3

import argparse
import os
import socket
import struct
import sys

###########
## client
###########
def send_file(sock: socket.socket, filename: str = os.path.split(sys.argv[0])[-1]):
    filesize = os.path.getsize(filename)
    sock.sendall(struct.pack("<Q", filesize))
    with open(filename, "rb") as f:
        while read_bytes := f.read(1024):
            sock.sendall(read_bytes)
            print(f"Sent {len(read_bytes)} bytes")
    return

def client_main(hostname: str, port: int, filename: str):
    target = (str(hostname), int(port))
    with socket.create_connection(target) as connection:
        print(f"Connect server: '{target}'")
        print(f"Send file: '{filename}'")
        send_file(connection, filename)
        print("Sent file complete")
    return

##########
## server
##########
def receive_file(sock: socket.socket):
    fmt = "<Q"
    expected_bytes = struct.calcsize(fmt)
    received_bytes = 0
    stream = bytes()
    while received_bytes < expected_bytes:
        chunk = sock.recv(expected_bytes - received_bytes)
        stream += chunk
        received_bytes += len(chunk)
    filesize = struct.unpack(fmt, stream)[0]
    return filesize

def serv_main(hostname: str, port: int):
    listening = (str(hostname), int(port))
    with socket.create_server(listening) as server:
        print(f"Server start; await client connect at {listening}")
        conn, addr = server.accept()
        print(f"Connect from '{addr}'")
        receive_file(conn, "outputfilename")
        print("file received")
    return

# TODO
#def args_main():
#    parser = argparse.ArgumentParser()
#    parser.add_argument("k

if __name__ == "__main__":
    target_host = "rock.bobx.org"
    target_port = 9999

    if len(sys.argv) > 1:
        _sendfile = sys.argv[1]
    else:
        _sendfile = sys.argv[0]
    print(f"using: '{_sendfile}'")

    client_main(target_host, target_port, _sendfile)
    print("fine.")

