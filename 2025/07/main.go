package main

import (
	"bytes"
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	w := 1 + bytes.IndexByte(in, '\n')
	h := len(in) / w
	first, last := 0, w-2
	var p1 int
	b := [150]int{}
	for y := 0; y < h; y++ {
	LL:
		for x := first; x <= last; x++ {
			switch in[x+y*w] {
			case 'S':
				b[x]++
				first = x - 1
				last = x + 1
				break LL
			case '^':
				if b[x] > 0 {
					b[x-1] += b[x]
					b[x+1] += b[x]
					b[x] = 0
					p1 += 1
					if x == first {
						first--
					}
					if x == last {
						last++
					}
				}
			}
		}
	}
	p2 := 0
	for j := first; j <= last; j++ {
		p2 += b[j]
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
