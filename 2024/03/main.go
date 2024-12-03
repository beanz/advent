package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	p1, p2 := 0, 0
	v := func(i int) byte {
		if i < len(in) {
			return in[i]
		}
		return '!'
	}
	m := func(i int, ch byte) bool {
		return v(i) == ch
	}
	n := func(i int) (int, int) {
		ch := v(i)
		n := 0
		for '0' <= ch && ch <= '9' {
			n = 10*n + int(ch-'0')
			i++
			ch = v(i)
		}
		return i, n
	}
	s := func(i int, s []byte) bool {
		for j, ch := range s {
			if !m(i+j, ch) {
				return false
			}
		}
		return true
	}
	mul := func(i int) (int, int, int, bool) {
		if !m(i, 'm') {
			return i + 1, 0, 0, false
		}
		if !m(i+1, 'u') {
			return i + 2, 0, 0, false
		}
		if !m(i+2, 'l') {
			return i + 3, 0, 0, false
		}
		if !m(i+3, '(') {
			return i + 4, 0, 0, false
		}
		var a int
		i, a = n(i + 4)
		if a == 0 {
			return i, 0, 0, false
		}
		if !m(i, ',') {
			return i, 0, 0, false
		}
		var b int
		i, b = n(i + 1)
		if b == 0 {
			return i, 0, 0, false
		}
		if !m(i, ')') {
			return i, 0, 0, false
		}
		return i + 1, a, b, true
	}
	do := true
	for i := 0; i < len(in); {
		var a, b int
		var ok bool
		switch {
		case s(i, []byte("do()")):
			do = true
			i += 4
		case s(i, []byte("don't()")):
			do = false
			i += 7
		default:
			i, a, b, ok = mul(i)
			if ok {
				p1 += a * b
				if do {
					p2 += a * b
				}
			}
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
