package logtail

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"time"
)

func LogTailer(file string, sleepSeconds string) error {
	// this works
	// consolidating this into method of PostExport type

	sleepDur, err := time.ParseDuration(sleepSeconds + "s")
	if err != nil {
		return err
	}

	f, err := os.Open(file)
	if err != nil {
		return err
	}

	defer f.Close()
	r := bufio.NewReader(f)

	for {
		line, err := r.ReadString('\n')
		if err != nil {
			if err == io.EOF {
				fmt.Println("EOF encountered! zzz . . . ", sleepSeconds, " seconds")
				time.Sleep(sleepDur)
				continue
			}
		}
		// though we're not printing the lines,
		// they should be "processed"
		fmt.Println(line)
	}
}
