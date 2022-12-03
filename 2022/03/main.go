package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func common(sets ...[]byte) int {
	s0 := 0
	for _, ch := range sets[0] {
		s0 |= 1 << (ch - 'A')
	}
	for _, s := range sets[1:] {
		s1 := 0
		for _, ch := range s {
			s1 |= 1 << (ch - 'A')
		}
		s0 &= s1
	}
	for v, s := 0, 1; s > 0; v, s = v+1, s<<1 {
		if s&s0 != 0 {
			if v > 26 {
				return 1 + v - 32
			}
			return 27 + v
		}
	}
	return 0
}

func Parts(in []byte) (int, int) {
	p1 := 0
	p2 := 0
	s := make([][]byte, 0, 3)
	j := 0
	for i, ch := range in {
		switch ch {
		case '\n':
			k := (i + j) / 2
			p := common(in[j:k], in[k:i])
			p1 += p
			s = append(s, in[j:i])
			if len(s) == 3 {
				p := common(s...)
				p2 += p
				s = s[:0]
			}
			j = i + 1
		}
	}
	return p1, p2
}

func main() {
	in := InputBytes(input)
	p1, p2 := Parts(in)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
