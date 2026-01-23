package main

import (
	"bufio"
	"flag"
	"fmt"
	"io"
	"os"
)

// this works up here too, and it would then be in 'global' scope
var targetFile = flag.String("file", "http-client.go", "File to read")

func main() {
	//	targetFile := flag.String("file", "http-client.go", "File to read")
	flag.Parse()

	fmt.Println("Reading file -> ", *targetFile)

	f, err := os.Open(*targetFile)
	if err != nil {
		fmt.Println("Error opening file! ", err)
		return
	}
	defer f.Close()

	r := bufio.NewReader(f)
	for {
		pline, err := r.ReadString('\n')
		if err != nil {
			if err == io.EOF {
				fmt.Println("End of File!")
				return
			}
			fmt.Println("Other Error! ", err)
			break
		}
		// fmt.Println inserts extra newline while
		// fmt.Print does not
		fmt.Print(pline)
	}
}
