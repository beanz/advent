package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	first := 0
	floor := 0
	for i, ch := range in {
		switch ch {
		case '(':
			floor++
		case ')':
			floor--
		}
		if first == 0 && floor < 0 {
			first = i + 1
		}
	}
	return floor, first
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark bool
