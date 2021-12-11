package main

import (
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Calc(in []byte) (int, int) {
	p1 := 0
	p2 := make([]int, 0, len(in)/90)
	st := make([]byte, 0, 90) // input is 90 chars per line
	for i := 0; i < len(in); i++ {
		ch := in[i]
		if ch == '(' || ch == '[' || ch == '{' || ch == '<' {
			rch := ch + 2
			if rch == 42 {
				rch--
			}
			st = append(st, rch)
		} else if ch != '\n' {
			var exp byte
			exp, st = st[len(st)-1], st[:len(st)-1]
			if ch != exp {
				p1 += score1(ch)
				for ; in[i] != '\n'; i++ {
				}
				st = st[:0] // reset stack
				continue
			}
		} else { // '\n'
			s := 0
			for j := len(st) - 1; j >= 0; j-- {
				s = s*5 + score2(st[j])
			}
			p2 = append(p2, s)
			st = st[:0] // reset stack
		}
	}
	return p1, SimpleMedianN(p2, len(p2)/2)
}

func main() {
	p1, p2 := Calc(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false

func score1(b byte) int {
	switch b {
	case ')':
		return 3
	case ']':
		return 57
	case '}':
		return 1197
	case '>':
		return 25137
	default:
		panic("bad score1 " + string(b))
	}
}

func score2(b byte) int {
	switch b {
	case ')':
		return 1
	case ']':
		return 2
	case '}':
		return 3
	case '>':
		return 4
	default:
		panic("bad score1 " + string(b))
	}
}
