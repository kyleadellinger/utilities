package main

import (
	"bufio"
	"fmt"
	"net"
	"os"
)

func main() {

	arguments := os.Args
	if len(arguments) == 1 {
		fmt.Println("Please provide host:port")
		return
	}

	connect := arguments[1]
	c, err := net.Dial("tcp", connect)
	if err != nil {
		fmt.Println("Error on dial! ", err)
		return
	}
	PlainCall(c)
}

func PlainCall(conn net.Conn) {

	defer conn.Close()

	default_msg := "GET QUEUE LENGTH"
	_, err := fmt.Fprintf(conn, default_msg+"\n")
	if err != nil {
		fmt.Println("Error on conn write: ", err)
	}

	response, _ := bufio.NewReader(conn).ReadString('\n')
	fmt.Print("Response -> : ", response, "\n")

	fmt.Println("Client complete") // remove
	return

}
