package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	p1 := 0
	for i := 96; i < len(in); {
		j, w := ChompUInt[int](in, i)
		j, h := ChompUInt[int](in, j+1)
		a := w * h
		b := 0
		i = j + 2
		for k := 0; k < 6; k++ {
			var n int
			i, n = ChompUInt[int](in, i)
			b += n * 9
			i++
		}
		if a >= b {
			p1++
		}
	}
	return p1, 0
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %v\n", p1)
		fmt.Printf("Part 2: %v\n", p2)
	}
}

var benchmark = false
