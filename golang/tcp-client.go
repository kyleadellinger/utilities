package main

import (
	"flag"
	"fmt"
	"net"
)

var address = flag.String("a", ":9000", "Server address")

func main() {
	flag.Parse()
	conn, err := net.Dial("tcp", *address)
	if err != nil {
		panic(err)
	}

	// Send a line of text
	text := []byte("Hello server")
	conn.Write(text)

	// Read response
	response := make([]byte, len(text))
	conn.Read(response)
	fmt.Println(string(response))
	conn.Close()
}
