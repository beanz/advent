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
	var w int
	for i, ch := range in {
		if ch == '\n' {
			w = i + 1
			break
		}
	}
	isDigit := func(ch byte) bool { return '0' <= ch && ch <= '9' }
	_ = w
	i := 0
	var seen [141 * 141]int
	for i < len(in) {
		ch := in[i]
		if !isDigit(ch) {
			i++
			continue
		}
		n := int(ch - '0')
		j := i + 1
		for ; j < len(in) && isDigit(in[j]); j++ {
			n = n*10 + int(in[j]-'0')
		}
		l := j - i
		sym, k := symbol(in, i, l, w)
		if sym != '.' {
			p1 += n
			if seen[k] != 0 {
				p2 += seen[k] * n
			} else {
				seen[k] = n
			}
		}
		i = j
	}
	return p1, p2
}

func symbol(in []byte, i, l, w int) (byte, int) {
	check := func(i int) bool {
		return in[i] != '.' && in[i] != '\n' && !('0' <= in[i] && in[i] <= '9')
	}
	for o := w - l; o <= w+1; o++ {
		if i >= o {
			if check(i - o) {
				return in[i-o], i - o
			}
		}
	}
	if i > 0 {
		if check(i - 1) {
			return in[i-1], i - 1
		}
	}
	if i+l < len(in) {
		if check(i + l) {
			return in[i+l], i + l
		}
	}
	for j := i + w - 1; j <= i+w+l; j++ {
		if j < len(in) {
			if check(j) {
				return in[j], j
			}
		}
	}
	return '.', 0
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
