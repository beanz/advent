package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

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

func main() {
	b := InputBytes(input)
	p1, p2 := calc(b)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark bool
