package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	p1 := 0
	p2 := 0
	for i := 0; i < len(in); {
		switch in[i] {
		case '"':
			p1 += 1
			p2 += 1
			i++
		case '\\':
			i++
			if in[i] == 'x' {
				p1 += 3
				p2++
				i += 3
			} else {
				p1++
				p2 += 2
				i++
			}
		case '\n':
			p2 += 2
			i++
		default:
			i++
		}
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

var benchmark bool
