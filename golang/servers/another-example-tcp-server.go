package main

import (
	"bufio"
	"log"
	"net"
)

func handleConnection(conn net.Conn) {
	defer conn.Close()
	reader := bufio.NewReader(conn)
	s, err := reader.ReadString('\n')
	if err != nil {
		log.Fatalln("Error handling connection! -> ", err)
	}
	log.Printf("Msg: %s", s) // also to be removed
	writer := bufio.NewWriter(conn)
	if _, err := writer.WriteString(s); err != nil {
		log.Fatalln("Unable to write data")
	}
	writer.Flush()
}

func main() {
	listen_addr := ":9002"
	listener, err := net.Listen("tcp", listen_addr)
	if err != nil {
		log.Fatalln("Error on start!", err)
		return
	}
	log.Println("Server start, listening on: ", listen_addr)
	for {
		conn, err := listener.Accept()
		log.Println("Receive connection") // this will be removed
		if err != nil {
			log.Fatalln("Error!", err)
		}
		go handleConnection(conn)
	}
}
