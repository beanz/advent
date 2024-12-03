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
	i := 0
	v := func() byte {
		if i < len(in) {
			return in[i]
		}
		return '!'
	}
	n := func() int {
		ch := v()
		n := 0
		for '0' <= ch && ch <= '9' {
			n = 10*n + int(ch-'0')
			i++
			ch = v()
		}
		return n
	}
	do := 1
	for i < len(in) {
		switch v() {
		case 'd':
			i++
			if v() != 'o' {
				continue
			}
			i++
			switch v() {
			case '(':
				i++
				if v() != ')' {
					continue
				}
				do = 1
			case 'n':
				i++
				if v() != '\'' {
					continue
				}
				i++
				if v() != 't' {
					continue
				}
				i++
				if v() != '(' {
					continue
				}
				i++
				if v() != ')' {
					continue
				}
				i++
				do = 0
			default:
				continue
			}
		case 'm':
			i++
			if v() != 'u' {
				continue
			}
			i++
			if v() != 'l' {
				continue
			}
			i++
			if v() != '(' {
				continue
			}
			i++
			a := n()
			if a == 0 {
				continue
			}
			if v() != ',' {
				continue
			}
			i++
			b := n()
			if b == 0 {
				continue
			}
			if v() != ')' {
				continue
			}
			i++
			p1 += a * b
			p2 += do * a * b
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

var benchmark = false
