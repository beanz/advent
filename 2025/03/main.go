package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func best(line []byte, o, rem int) (int, int) {
	r := line[o]
	for i := o + 1; i < len(line)-rem; i++ {
		if line[i] > r {
			r, o = line[i], i
			if r == '9' {
				break
			}
		}
	}
	return int(r - '0'), o + 1
}

func part(line []byte, n int) int {
	r := 0
	i := 0
	var d int
	for rem := n - 1; rem >= 0; rem-- {
		d, i = best(line, i, rem)
		r *= 10
		r += d
	}
	return r
}

func Parts(in []byte, args ...int) (int, int) {
	p1, p2 := 0, 0
	i := 0
	VisitLines(in, &i, func(line []byte) {
		if len(line) == 0 {
			return
		}
		r1 := part(line, 2)
		p1 += r1
		r2 := part(line, 12)
		p2 += r2
	})
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
