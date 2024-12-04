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
	p1, p2 := 0, 0
	iy := bytes.IndexByte(in, '\n') + 1
	for i := 0; i < len(in); i++ {
		if in[i] != 'X' {
			continue
		}
		mas := func(o int) {
			if !(0 <= i+o*3 && i+o*3 < len(in)) {
				return
			}
			if in[i+o] == 'M' && in[i+o*2] == 'A' && in[i+o*3] == 'S' {
				p1++
			}
		}
		mas(-1 + -1*iy)
		mas(0 + -1*iy)
		mas(1 + -1*iy)
		mas(-1 + 0*iy)
		mas(1 + 0*iy)
		mas(-1 + 1*iy)
		mas(0 + 1*iy)
		mas(1 + 1*iy)
	}
	// sliding X offsets
	for i, i2, i3, i4, i5 := 0, 2, 1+iy, 2*iy, 2+2*iy; i5 < len(in); i, i2, i3, i4, i5 = i+1, i2+1, i3+1, i4+1, i5+1 {
		if in[i3] != 'A' {
			continue
		}
		if (in[i] == 'M' && in[i5] == 'S' || in[i] == 'S' && in[i5] == 'M') &&
			(in[i2] == 'M' && in[i4] == 'S' || in[i2] == 'S' && in[i4] == 'M') {
			p2++
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

var benchmark = false
