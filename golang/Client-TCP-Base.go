// base example/template for tcp client
package main

import (
	"flag"
	"log"
	"net"
)

var callAddress = flag.String("a", ":8000", "Target server address")

func main() {
	flag.Parse()
	conn, err := net.Dial("tcp", *address)
	if err != nil {
		log.Fatalln("err dialing address:", err)
	}

	text := []byte("Hello echo server")
	conn.Write(text)

	// read response
	response := make([]byte, len(text))
	conn.Read(response)
	log.Println(string(response))
	conn.Close()
}
