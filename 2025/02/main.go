package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func invalid(id int) int {
	b := fmt.Append(nil, id)
	l := len(b)
OUTER:
	for i := 2; i <= len(b); i++ {
		if l%i != 0 {
			continue
		}
		m := l / i
		for j := m; j < len(b); j++ {
			if b[j] != b[j%m] {
				continue OUTER
			}
		}
		return i
	}
	return 0
}

func Parts(in []byte, args ...int) (int, int) {
	p1, p2 := 0, 0
	for i := 0; i < len(in); i++ {
		var s, e int
		i, s = ChompUInt[int](in, i)
		i++
		i, e = ChompUInt[int](in, i)
		for j := s; j <= e; j++ {
			n := invalid(j)
			if n >= 2 {
				p2 += j

				if n == 2 {
					p1 += j
				}
			}
		}
	}
	return p1, p2
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %v\n", p1)
		fmt.Printf("Part 2: %v\n", p2)
	}
}

var benchmark = false
