package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
)

func lineByLine(file string) error {
	// obtain a file handle; check for errors
	f, err := os.Open(file)
	if err != nil {
		return err
	}
	// 'defer' - LIFO; when surrounding function returns, deferred
	// statements are executed. eg file handle is closed
	defer f.Close()
	// create buffered i/o reader
	r := bufio.NewReader(f)

	// basically 'while'
	for {
		// read line and checking for errors
		line, err := r.ReadString('\n')
		// check for specific EOF error
		if err == io.EOF {
			if len(line) != 0 {
				fmt.Println("Note! EOF encountered: ") // this doesn't print, which is expected, though not positive exactly why
				// i think this is if there is data on last line as EOF is reached, but not a newline char, in this example.
				fmt.Println(line)
			}
			break
		}
		if err != nil {
			fmt.Printf("error reading file %s", err)
			return err
		}
		fmt.Print(line)
	}
	return nil
}

func main() {
	// first provided command line arg as file input to print lines from
	if len(os.Args) > 1 {
		targetFile := os.Args[1]
		// func call; only an error could be returned from func
		err := lineByLine(targetFile)

		if err != nil {
			fmt.Println("Error! ", err)
		}
	} else {
		fmt.Println("I was expecting a filename!")
		return
	}
}
