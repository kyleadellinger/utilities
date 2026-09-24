#!/usr/bin/env python3

"""
ref:

https://docs.cognex.com/dmst_2620/web/EN/Comms_Prog_Manual/Content/Topics/PDF/DMCAP/TransferringImagesOverTCP.htm?TocPath=DataMan%20Application%20Development%7C_____3

"""

import socket
import struct

# host machine IP address and port 
server_ip = "<insert host ip>"
server_port = 4444

# Create a socket object 
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Bind the socket to a specific address and port 
s.bind((server_ip, server_port))

# Start listening for incoming connections 
s.listen(1)

print("Server is listening on port", server_port)

filesReceived = 0

try:
    # Receive data from the client 
    while True:
        # Accept a connection 
        print("Waiting on connection...")
        c, addr = s.accept()
        print("Got connection from", addr)

        data = ""

        while True:
            # Read header 
            data = c.recv(8 + 128)
            print("Received header length", len(data))
            if not data:
                print("Header not received, aborting read")
                break

            fileSize = 0
            fileSizeBuffer = data[:4]
            fileSize = struct.unpack("<I", fileSizeBuffer)[0]
            print("FileSize", fileSize)
            fileTypeBuffer = data[4:8]
            fileType = struct.unpack("<I", fileTypeBuffer)[0]
            print("FileType", fileType)
            fileNameBuffer = data[8:]
            fileName = struct.unpack("128s", fileNameBuffer)[0]
            print("FileName", fileName.decode())

            # Read data in 1024 packets 

            received = 0
            while received < fileSize:
                readPacketSize = 1024
                if fileSize - received < 1024:
                    readPacketSize = fileSize - received
                data = c.recv(readPacketSize)
                received += len(data)

                if not data:
                    print("Got bad data packet aborting file read")
                    break

            # Save the file 
            filesReceived += 1
            print("Files Received", filesReceived, "Last file size:", fileSize)
            print("")

except KeyboardInterrupt:
    print("\nExiting")

