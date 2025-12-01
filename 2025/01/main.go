package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	a1, a2 := 0, 0
	p := 50
	for i := 0; i < len(in); i++ {
		inc := 1
		if in[i] == 'L' {
			inc = -1
		}
		i++
		var n int
		i, n = ChompUInt[int](in, i)
		for range n {
			p += inc
			p %= 100
			if p == 0 {
				a2++
			}
		}
		if p == 0 {
			a1++
		}
	}
	return a1, a2
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %v\n", p1)
		fmt.Printf("Part 2: %v\n", p2)
	}
}

var benchmark = false
