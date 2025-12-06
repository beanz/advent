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
	w := bytes.IndexByte(in, '\n') + 1
	h := len(in)/w - 1
	p1, p2 := 0, 0
	skip := func(i int) int {
		for ; i < len(in) && in[i] <= ' '; i++ {
		}
		return i
	}
	for i := h * w; i < len(in); {
		op := in[i]
		j := i
		i = skip(i + 1)
		if op == '+' {
			p1 += add(in, j-w*h, 1, w, i-j-1, h)
			p2 += add(in, j-w*h, w, 1, h, i-j-1)
		} else {
			p1 += mul(in, j-w*h, 1, w, i-j-1, h)
			p2 += mul(in, j-w*h, w, 1, h, i-j-1)
		}
	}
	return p1, p2
}

func add(in []byte, i, digitInc, numInc, digits, nums int) int {
	res := 0
	for j := range nums {
		n := 0
		for k := range digits {
			ch := in[i+k*digitInc+j*numInc]
			if ch == ' ' {
				continue
			}
			n = 10*n + int(ch&0xf)
		}
		res += n
	}
	return res
}

func mul(in []byte, i, digitInc, numInc, digits, nums int) int {
	res := 1
	for j := range nums {
		n := 0
		for k := range digits {
			ch := in[i+k*digitInc+j*numInc]
			if ch == ' ' {
				continue
			}
			n = 10*n + int(ch&0xf)
		}
		res *= n
	}
	return res
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %v\n", p1)
		fmt.Printf("Part 2: %v\n", p2)
	}
}

var benchmark = false
