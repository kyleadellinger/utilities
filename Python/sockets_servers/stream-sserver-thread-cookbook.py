#!/usr/bin/python3

import socket
from socketserver import StreamRequestHandler, ThreadingTCPServer, TCPServer

class EchoHandler(StreamRequestHandler):

    def handle(self):
        print("Connection from: ", self.client_address)
        for line in self.rfile:
            self.wfile.write(line)

if __name__ == "__main__":

    serv = ThreadingTCPServer(("", 9002), EchoHandler, bind_and_activate=False)
    serv.socket.setsockopt(socket.SOL, socket.SO_REUSEADDR, True)
    serv.server_bind()
    serv.server_activate()
    serv.serve_forever()
