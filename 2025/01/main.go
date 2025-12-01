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
		dir := int(in[i]&0x2) - 1 // R => 1, L = -1
		i++
		var n int
		i, n = ChompUInt[int](in, i)
		a2 += n / 100
		n %= 100
		if p == 0 && dir == -1 {
			p = 100
		}
		p += dir * n
		if p <= 0 {
			a2 += 1
			if p < 0 {
				p += 100
			}
		} else if p >= 100 {
			a2 += 1
			p -= 100
		}
		if p == 0 {
			a1 += 1
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
