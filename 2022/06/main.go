package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte) (int, int) {
	p1 := Part(in, 4, 0)
	return p1, Part(in, 14, p1-4)
}

func Part(in []byte, l int, offset int) int {
	for i := offset; i < len(in)-l; i++ {
		ok := true
	LOOP:
		for j := i; j < i+l; j++ {
			for k := j + 1; k < i+l; k++ {
				if in[j] == in[k] {
					ok = false
					i = j
					break LOOP
				}
			}
		}
		if ok {
			return i + l
		}
	}
	return -1
}

func main() {
	in := InputBytes(input)
	p1, p2 := Parts(in)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
