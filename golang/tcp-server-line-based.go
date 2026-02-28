// line-based TCP server
package main

import (
	"net"
)

// limit incoming line length to 1kib
const MaxLineLength = 1024

func handleConnection(conn net.Conn) error {
	defer conn.Close()
	// wrap connection wtih limited reader to prevent client from sending unbound amount of data
	limiter := &io.LimitedReader{
		R: conn,
		N: MaxLineLength+1,
	}

	reader := bufio.NewReader(limiter)
	for {
		bytes, err := reader.ReadBytes(byte('\n'))
		if err != nil {
			if err != io.EOF {
				log.Println("err reading:", err)
				return err
			}
			if limiter.N==0 {
				return fmt.Errorf("Received line exceeding limit")
			}
			return nil
		}
		// reset limiter
		limiter.N=MaxLineLength+1

		// process line
		if _, err := conn.Write(bytes); err != nil {
			return err
		}
	}
}


