// base example for TCP server setup
package main

import (
	"flag"
	"io"
	"log"
	"net"
)

var listenAddress = flag.String("a", ":8000", "Listen address")

func main() {
	flag.Parse()

	// create tcp listener
	listener, err := net.Listen("tcp", *listenAddress)
	if err != nil {
		log.Fatalln("err creating listener:", err)
	}

	log.Println("Listening for TCP connections on:", listener.Addr())
	defer listener.Close()

	// listen for tcp connections
	for {
		conn, err := listener.Accept()
		if err != nil {
			log.Fatalln("error:", err)
		}
		go handleConnection(conn)
	}
}

func handleConnection(conn net.Conn) {
	io.Copy(conn, conn)
}
