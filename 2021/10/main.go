package main

import (
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
	"sort"
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
	return p1, MedianOfMedians(p2, len(p2)/2)
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

func MedianOfMedians(inp []int, n int) int {
	if len(inp) <= 10 {
		return SimpleMedianN(inp, n)
	}
	lhs := make([]int, 0, len(inp))
	equal := make([]int, 0, len(inp))
	rhs := make([]int, 0, len(inp))
	numSlices := (len(inp) + 4) / 5
	meds := make([]int, 0, numSlices)
	for {

		numSlices = (len(inp) + 4) / 5 // redundant on first iteration
		meds = meds[:0]
		for i := 0; i < numSlices; i++ {
			start := i * 5
			end := start + 5
			if end > len(inp) {
				end = len(inp)
			}
			sort.Ints(inp[start:end])
			meds = append(meds, inp[(start+end)/2])
		}
		pivot := MedianOfMedians(meds, len(meds)/2)
		for i := range inp {
			if inp[i] < pivot {
				lhs = append(lhs, inp[i])
			} else if inp[i] > pivot {
				rhs = append(rhs, inp[i])
			} else {
				equal = append(equal, inp[i])
			}
		}
		var next []int
		if n < len(lhs) {
			next = lhs
		} else if n < len(lhs)+len(equal) {
			return pivot
		} else {
			next, n = rhs, n-len(lhs)-len(equal)
		}
		if len(next) <= 10 {
			return SimpleMedianN(next, n)
		}
		inp = inp[:0]
		for _, v := range next {
			inp = append(inp, v)
		}
		lhs = lhs[:0]
		equal = equal[:0]
		rhs = rhs[:0]
	}
}

func SimpleMedianN(inp []int, n int) int {
	sort.Ints(inp)
	return inp[n]
}
