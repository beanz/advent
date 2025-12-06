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
	w := bytes.IndexByte(in, '\n')
	h := len(in) / (w + 1)
	p2 := 0
	nums := make([]int, 0, 5)
	for i := w - 1; i >= 0; i-- {
		n := 0
		for y := range h - 1 {
			if in[i+y*(w+1)] == ' ' {
				continue
			}
			n = 10*n + int(in[i+y*(w+1)]-'0')
		}
		if n == 0 {
			p2 += apply(in[i+1+(h-1)*(w+1)], nums...)
			nums = nums[:0]
		} else {
			nums = append(nums, n)
		}
	}
	i := (h - 1) * (w + 1)
	p2 += apply(in[i], nums...)
	p1 := 0
	lines := make([]int, h-1)
	for y := range h - 1 {
		lines[y] = y * (w + 1)
	}
	skip := func(i int) int {
		for ; i < len(in) && in[i] == ' '; i++ {
		}
		return i
	}
	for i < len(in)-1 {
		op := in[i]
		i = skip(i + 1)
		nums = nums[:0]
		for y := range h - 1 {
			lines[y] = skip(lines[y])
			j, n := ChompUInt[int](in, lines[y])
			lines[y] = j + 1
			nums = append(nums, n)
		}
		p1 += apply(op, nums...)
	}
	return p1, p2
}

func apply(op byte, nums ...int) int {
	if op == '+' {
		return Sum(nums...)
	}
	return Product(nums...)
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %v\n", p1)
		fmt.Printf("Part 2: %v\n", p2)
	}
}

var benchmark = false
