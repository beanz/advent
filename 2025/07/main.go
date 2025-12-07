package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	var x, p1 int
	b := [256]int{}
	for i := 0; i < len(in); i++ {
		switch in[i] {
		case 'S':
			b[x]++
		case '\n':
			x = 0
			continue
		case '^':
			if b[x] > 0 {
				b[x-1] += b[x]
				b[x+1] += b[x]
				b[x] = 0
				p1 += 1
			}
		}
		x++
	}
	p2 := 0
	for _, c := range b {
		p2 += c
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
