package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(inp []byte) (int, int) {
	s0 := 0
	s1 := 0
	s2 := 0
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
				if s > s0 {
					s, s0 = s0, s
				}
				if s > s1 {
					s, s1 = s1, s
				}
				if s > s2 {
					s2 = s
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
	return max, s0 + s1 + s2
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
