package main

import (
	_ "embed"
	"fmt"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(start, end int) (int, int) {
	p1, p2 := 0, 0
	s := make([]int, 6)
	for i := start; i <= end; i++ {
		if i < 100000 || i > 999999 {
			continue
		}
		s[5] = i % 10
		s[4] = (i / 10) % 10
		if s[4] > s[5] {
			continue
		}
		s[3] = (i / 100) % 10
		if s[3] > s[4] {
			continue
		}
		s[2] = (i / 1000) % 10
		if s[2] > s[3] {
			continue
		}
		s[1] = (i / 10000) % 10
		if s[1] > s[2] {
			continue
		}
		s[0] = (i / 100000) % 10
		if s[0] > s[1] {
			continue
		}
		if s[0] == s[1] || s[1] == s[2] || s[2] == s[3] ||
			s[3] == s[4] || s[4] == s[5] {
			p1++
		}
		if (s[0] == s[1] && s[1] != s[2]) ||
			(s[1] == s[2] && s[2] != s[3] && s[1] != s[0]) ||
			(s[2] == s[3] && s[3] != s[4] && s[2] != s[1]) ||
			(s[3] == s[4] && s[4] != s[5] && s[3] != s[2]) ||
			(s[4] == s[5] && s[4] != s[3]) {
			p2++
		}
	}
	return p1, p2
}

func main() {
	lines := InputLines(input)
	i := ReadInts(strings.Split(lines[0], "-"))
	p1, p2 := Parts(i[0], i[1])
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
