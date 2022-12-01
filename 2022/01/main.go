package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(inp []byte) (int, int) {
	sums := make([]int, 0, 3)
	var s int
	var n int
	eol := false
	max := 0
	for _, ch := range inp {
		switch ch {
		case '\n':
			if eol {
				if s > max {
					max = s
				}
				if len(sums) < 3 {
					sums = append(sums, s)
				} else {
					for i := range sums {
						if s > sums[i] {
							sums[i], s = s, sums[i]
						}
					}
				}
				s = 0
				eol = false
			} else {
				s += n
				n = 0
				eol = true
			}
		default:
			eol = false
			n = 10*n + int(ch-'0')
		}
	}
	return max, sums[0] + sums[1] + sums[2]
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
