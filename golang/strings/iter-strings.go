package main

import (
	"fmt"
	"os"
)

// iterate over given string to produce bytes
func iterStringToBytes(s string) {
	for i := 0; i < len(s); i++ {
		fmt.Println("Index:", i, "Byte:", s[i], "String:", string(s[i]))
	}
}

// iterate over given string to produce runes
func iterStringToRunes(s string) {
	for index, c := range s {
		fmt.Println("Index:", index, "Rune:", c, "String:", string(c))
	}
}

func main() {
	exampleString := "A string is an immutable sequence of bytes"
	usageString := "Expected single arg, either 'bytes' or 'runes'"
	if len(os.Args) <= 1 {
		fmt.Println(usageString)
		os.Exit(1)
	}
	if os.Args[1] == "bytes" {
		fmt.Println("Iterate bytes:")
		iterStringToBytes(exampleString)
		return
	}
	if os.Args[1] == "runes" {
		fmt.Println("Iterate runes:")
		iterStringToRunes(exampleString)
		return
	}
	fmt.Println(usageString)
	os.Exit(1)
}
