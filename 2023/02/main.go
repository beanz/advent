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
		i += 2
		possible := true
		for in[i] != '\n' {
			for ; in[i] != ';' && in[i] != '\n'; i++ {
				var n int
				i, n = ChompInt[int](in, i)
				i++
				switch in[i] {
				case 'r':
					if n > mr {
						mr = n
					}
					if n > 12 {
						possible = false
					}
					i += 3
				case 'g':
					if n > mg {
						mg = n
					}
					if n > 13 {
						possible = false
					}
					i += 5
				case 'b':
					if n > mb {
						mb = n
					}
					if n > 14 {
						possible = false
					}
					i += 4
				}
				if in[i] == ';' {
					i += 2
					break
				}
				if in[i] == '\n' {
					break
				}
				i++
			}
		}
		if possible {
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
