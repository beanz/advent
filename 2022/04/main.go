package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func NextUInt(in []byte, i int) (j int, n int) {
	j = i
	for ; '0' <= in[j] && in[j] <= '9'; j++ {
		n = 10*n + int(in[j]-'0')
	}
	return
}

func Parts(in []byte) (int, int) {
	p1, p2 := 0, 0
	for i := 0; i < len(in); {
		var l0, h0, l1, h1 int
		i, l0 = NextUInt(in, i)
		i, h0 = NextUInt(in, i+1)
		i, l1 = NextUInt(in, i+1)
		i, h1 = NextUInt(in, i+1)
		if l0 >= l1 && h0 <= h1 || l1 >= l0 && h1 <= h0 {
			p1++
		}
		if !(l0 > h1 || l1 > h0) {
			p2++
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
