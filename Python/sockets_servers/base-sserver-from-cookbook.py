#!/usr/bin/env python3

from socketserver import BaseRequestHandler, TCPServer

class EchoHandler(BaseRequestHandler, TCPServer):
    
    def handle(self):
        print(f"Received connection from: {self.client_address}")
        while True:
            msg = self.request.recv(8192)
            if not msg:
                break
            self.request.send(msg)

if __name__ == "__main__":
    serv = TCPServer(("", 20000), EchoHandler)
    serv.serve_forever()

