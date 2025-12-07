package main

import (
	"bytes"
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func search(in []byte, w, h, s int) int {
	if s >= len(in) {
		return 0
	}
	ch := in[s]
	if ch == '@' {
		return 0
	}
	if ch == '^' {
		in[s] = '@'
		return 1 + search(in, w, h, s-1) + search(in, w, h, s+1)
	}
	return search(in, w, h, s+w)
}

func search2(in []byte, w, h, s int, cache []int) int {
	if cache[s] != 0 {
		return cache[s]
	}
	if s >= len(in) {
		return 1
	}
	ch := in[s]
	var r int
	if ch == '^' || ch == '@' {
		r = search2(in, w, h, s-1, cache) + search2(in, w, h, s+1, cache)
	} else {
		r = search2(in, w, h, s+w, cache)
	}
	cache[s] = r
	return r
}

func Parts(in []byte, args ...int) (int, int) {
	w := bytes.IndexByte(in, '\n') + 1
	h := len(in) / w
	s := bytes.IndexByte(in, 'S')
	cache := [20480]int{}
	p1 := search(in, w, h, s)
	p2 := search2(in, w, h, s, cache[:])
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
