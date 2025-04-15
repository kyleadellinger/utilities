package main

import (
    "bufio"
    "fmt"
    "net"
    "os"
    "strings"
)

func main() {
    // expect command line args:
    arguments := os.Args
    if len(arguments) == 1 {
        fmt.Println("Please provide 'host:port'")
        return
    }
    // read details of tcp server to connect to:
    connect := arguments[1]
    c, err := net.Dial("tcp", connect)
    if err != nil {
        fmt.Println(err)
        return
    }
    // a successful net.Dial() returns open connection (a net.Conn interface)
    // which is a generic stream-oriented network connection
    for {
        reader := bufio.NewReader(os.Stdin)
        fmt.Print(">> ")
        text, _ := reader.ReadString('\n')
        fmt.Fprintf(c, text+"\n")
        message, _ := bufio.NewReader(c).ReadString('\n')
        fmt.Print("->: " + message)
        if strings.TrimSpace(string(text)) == "STOP" {
            fmt.Println("TCP client exiting ...")
            return
        }
    }
}


