package main

import (
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

func calc(in []byte) (int, int) {
	co, cc := 0, 0
	first := 0
	floor := 0
	for i, ch := range in {
		switch ch {
		case '(':
			floor++
			co++
		case ')':
			floor--
			cc++
		}
		if first == 0 && floor < 0 {
			first = i + 1
		}
	}
	return co - cc, first
}

func main() {
	b := ReadInputBytes()
	p1, p2 := calc(b)
	fmt.Printf("Part 1: %d\n", p1)
	fmt.Printf("Part 2: %d\n", p2)
}
