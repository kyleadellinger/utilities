#!/usr/bin/env python3

import asyncio
import logging

from collections import Counter

C = Counter({'callcount': 0})

logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)
logFMT = logging.Formatter("%(asctime)s - %(levelname)s - %(funcName)s - %(message)s")

log_file = "./_async_server.log"
log_file_h = logging.FileHandler(log_file)
log_file_h.setLevel(logging.DEBUG)
log_file_h.setFormatter(logFMT)
logger.addHandler(log_file_h)

async def handle_echo(reader, writer):
    C['callcount'] += 1
    data = await reader.read(100)
    message = data.decode()
    addr = writer.get_extra_info("peername")
    #print(f"Received message {message!r} from {addr!r}")
    logger.debug("Message recv: %s from %s" % (message, addr))

    #print(f"Send message {message!r}")
    writer.write(data)
    await writer.drain()

    #print("Close connection")
    writer.close()
    await writer.wait_closed()
    logger.debug("Count: %s", C)

async def main():
    server = await asyncio.start_server(
            handle_echo, '127.0.0.1', 8888)
    addrs = ", ".join(str(sock.getsockname()) for sock in server.sockets)
    print(f"Serving on {addrs}")

    async with server:
        await server.serve_forever()

    logger.debug("This is after the with statement")

if __name__ == "__main__":
    asyncio.run(main())

