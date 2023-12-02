package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte) (int, int) {
	p1, p2 := 0, 0
	for i := 0; i < len(in); {
		mr, mg, mb := 1, 1, 1
		var id int
		i, id = ChompInt[int](in, i+5)
		for in[i] != '\n' {
			i += 2
			var n int
			i, n = ChompInt[int](in, i)
			i++
			switch in[i] {
			case 'r':
				if n > mr {
					mr = n
				}
				i += 3
			case 'g':
				if n > mg {
					mg = n
				}
				i += 5
			case 'b':
				if n > mb {
					mb = n
				}
				i += 4
			}
		}
		if mr <= 12 && mg <= 13 && mb <= 14 {
			p1 += id
		}
		p2 += mr * mg * mb
		i++
	}
	return p1, p2
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
