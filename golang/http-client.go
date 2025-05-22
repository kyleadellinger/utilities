package main

import (
	"bufio"
	"flag"
	"fmt"
	"io"
	//   "os"
	"net/http"
	"strings"
)

// seems to print memory address both ways
//var cmdVerb = flag.String("method", "GET", "HTTP method to use")
//var cmdAddr = flag.String("url", "", "URL to call")

//func iterateMapPrinter(m map[string]string) (nil) {
// body should work, but func declaration is invalid
//   fmt.Println("Headers returned: ")
//  for k, v := range m {
//    fmt.Println("Key: ", k, " Value: ", v)
//}
// return nil
//}

func main() {
	cmdVerb := flag.String("method", "GET", "HTTP method to use")
	cmdAddr := flag.String("url", "", "URL to call")
	cmdBose := flag.Bool("v", false, "Verbose output")
	cmdTLS := flag.Bool("s", false, "Enable SSL/TLS")
	cmdHeadersOnly := flag.Bool("head", false, "Only print headers from response")

	// the param, called 'value string', is the default value to use.

	// Parse must be called after all flags are defined and before they're accessed by program
	flag.Parse()
	if *cmdAddr == "" {
		fmt.Println("No address provided!")
		// terminate program. could and maybe should use like an os.Exit
		return
	}

	// it says 'flags may then be used directory. if you're using the flags themselves, they are all pointers; if you bind to variables, they're values.'
	if *cmdBose {
		fmt.Println("verb flag: ", *cmdVerb)
		fmt.Println("url flag: ", *cmdAddr)
	}
	// this prints as expected though, so i must be misinterpreting.

	// if 's' flag, ensure url prefix
	if *cmdTLS {
		adjUrl := strings.HasPrefix(*cmdAddr, "https://")
		if adjUrl != true {
			*cmdAddr = strings.Join([]string{"https://", *cmdAddr}, "")
		}
		if *cmdBose {
			fmt.Println("Adjusted URL [for TLS]: ", *cmdAddr)
		}
		// otherwise, ensure http prefix
	} else {
		adjUrl := strings.HasPrefix(*cmdAddr, "http://")
		if adjUrl != true {
			*cmdAddr = strings.Join([]string{"http://", *cmdAddr}, "")
		}
		if *cmdBose {
			fmt.Println("Adjusted URL: ", *cmdAddr)
		}
	}
	// actual call
	// create client (for control over headers and transports which idk how to do anyway)
	client := &http.Client{}
	resp, err := client.Get(*cmdAddr)
	if err != nil {
		fmt.Println("Error encountered! ", err)
		return
	}
	if *cmdBose {
		fmt.Println("Response Status: ", resp.Status)
		fmt.Println("Protocol: ", resp.Proto)
		// note: headers is a map; iterate over it for ease of viewing
		fmt.Println("Headers Returned: ")
		for k, v := range resp.Header {
			fmt.Println("Key: ", k, " Value: ", v)
		}
	//	fmt.Println("Request Sent: ", resp.Request)
	}
	if *cmdHeadersOnly {
		//fmt.Println("Headers Returned: ", resp.Header)
		for k, v := range resp.Header {
			fmt.Println("Key: ", k, " Value: ", v)
		}
		return
	}
	// extract and read/parse response from response struct
	reader := bufio.NewReader(resp.Body)
    fmt.Println("Response: ")
	for {
		r, err := reader.ReadString('\n')
		if err == io.EOF {
			//fmt.Println("EOF")
			return
		} else if err != nil {
			fmt.Println("Error in response! ", err)
			return
		}
		fmt.Print("->: " + r)
	}
	// end program
	return
}
