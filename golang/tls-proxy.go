// tcp proxy for tls termination
package main

import (
	"crypto/tls"
	"flag"
	"log"
	"net"
)

// for study
var (
	tlsAddress    = flag.String("a", ":4433", "TLS listen address")
	serverAddress = flag.String("s", ":8080", "Server addresses, comma separated")
	certificate   = flag.String("c", "", "Certificate file")
	certkey       = flag.String("k", "", "Key for certificate file")
)

func handleProxy(conn, targetConn net.Conn) {
	defer conn.Close()
	defer targetConn.Close()
	// copy data from client to server
	go io.Copy(targetConn, conn)
	// cody data from server to client
	io.Copy(conn, targetConn)
}

func main() {
	flag.Parse()

	// create external facing listener
	// load key pair
	cer, err := tls.LoadX509KeyPair(*certificate, *key)
	if err != nil {
		log.Fatalln("err load cert:", err)
	}

	// tls config for listener
	config := &tls.Config{
		Certificates: []tls.Certificate{cer},
	}

	// create listener
	tlsListener, err := tls.Listen("tcp", *tlsAddress, config)
	if err != nil {
		log.Fatalln("err start listener:", err)
	}

	defer tlsListener.Close()
	fmt.Println("Listen TLS on ", tlsListener.Add())

	// listen for incoming connections
	servers := strings.Split(*serverAddresses, ",")
	fmt.Println("Forwarding to servers:", servers)

	nextServer := 0
	for {
		// listen incoming
		conn, err := tlsListener.Accept()
		if err != nil {
			log.Fatalln("err incoming:", err)
		}
		retries := 0
		for {
			// select next server
			server := servers[nextServer]
			nextServer++
			if nextServer >= len(servers) {
				nextServer = 0
			}
			// start connection
			targetConn, err := net.Dial("tcp", server)
			if err != nil {
				retries++
				log.Println("error connecting to:", server, "continuing...")
				if retries > len(servers) {
					log.Fatalln("err: servers are not available:", err)
				}
				continue
			}
			// start proxy
			go handleProxy(conn, targetConn)
		}
	}
}
