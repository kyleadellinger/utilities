package main

import (
    "fmt"
    "os"
    "path/filepath"
)

func main() {
    arguments := os.Args
    if len(arguments) == 1 {
        fmt.Println("Args expected!")
        return
    }

    file := arguments[1]
    path := os.Getenv("PATH")
    pathSplit := filepath.SplitList(path)
    for _, directory := range pathSplit {
        fullPath := filepath.Join(directory, file)
        // does it exist ?
        fileInfo, err := os.Stat(fullPath)
        if err != nil {
            continue
        }

        mode := fileInfo.Mode()
        // is it a regular file ?
        if !mode.IsRegular() {
            continue
        }

        // is it executable ?
        if mode&0111 != 0 {
            fmt.Println(fullPath)
            return
        }
    }
}


