package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	p1, p2 := 0, 0
	i := 0
	copies := make([][2]int, 0, 8)
	for i < len(in) {
		c1 := [256]bool{}
		p := 0
		for in[i] != ':' {
			i++
		}
		i += 2
		VisitUints[int](in, '|', &i, func(n int) {
			c1[n] = true
		})
		i += 2
		VisitUints[int](in, '\n', &i, func(n int) {
			if c1[n] {
				p++
			}
		})
		if p > 0 {
			p1 += 1 << (p - 1)
		}
		n := 1
		k := 0
		for _, e := range copies {
			e[0]--
			n += e[1]
			if e[0] > 0 {
				copies[k] = e
				k++
			}
		}
		copies = copies[:k]
		p2 += n
		if p > 0 {
			copies = append(copies, [2]int{p, n})
		}
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
