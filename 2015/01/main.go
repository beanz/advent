package main

import (
	"fmt"
	"io/ioutil"
	"os"
)

func calc(in []byte) (int, int) {
	co, cc := 0, 0
	first := 0
	floor := 0
	for i, ch := range in {
		switch ch {
		case '(':
			floor++
			co++
		case ')':
			floor--
			cc++
		}
		if first == 0 && floor < 0 {
			first = i + 1
		}
	}
	return co - cc, first
}

func readFileBytes(file string) []byte {
	b, err := ioutil.ReadFile(file)
	if err != nil {
		panic(fmt.Sprintf("Failed to read %s: %s\n", file, err))
	}
	return b
}

func readInputBytes() []byte {
	if len(os.Args) < 2 {
		panic(fmt.Sprintf("Usage: %s <input.txt>\n", os.Args[0]))
	}
	file := os.Args[1]
	return readFileBytes(file)
}

func main() {
	b := readInputBytes()
	p1, p2 := calc(b)
	fmt.Printf("Part 1: %d\n", p1)
	fmt.Printf("Part 2: %d\n", p2)
}
