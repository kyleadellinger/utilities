
# std lib
import socket

# simple tcp port scanner
ip = "127.0.0.1"

portlist = [22, 23, 80]

for port in portlist:
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    result = sock.connect_ex((ip, port))
    print(f"{port} : {result}")
    sock.close()

# a result other than 0 indicates port is closed
