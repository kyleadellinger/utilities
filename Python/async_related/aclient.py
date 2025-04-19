#!/usr/bin/env python3

import asyncio
import sys

async def tcp_echo_client(host: str = "mail.bobx", port: int = 9002, message: str = "GET MAIL QUEUE\n") -> None:
    reader, writer = await asyncio.open_connection(
            host, port)
    print(f"Send: {message!r} to {host}")
    writer.write(message.encode())
    await writer.drain()

    data = await reader.read(100)
    print(f"Received: {data.decode()!r}")

    print("Close connection")
    writer.close()
    await writer.wait_closed()

if __name__ == "__main__":

    if len(sys.argv) > 1:
        host, port = sys.argv[1], int(sys.argv[2])
    else:
        host, port = "127.0.0.1", 8888

    asyncio.run(tcp_echo_client(host=host, port=port))

