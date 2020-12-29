package main

import (
	"fmt"

	. "github.com/beanz/advent2015/lib"
)

func Count1(s string) int {
	cc := 0
	for i := 0; i < len(s); i++ {
		ch := s[i]
		if ch == '\\' {
			switch s[i+1] {
			case '\\', '"':
				i++
				cc++
			case 'x':
				i += 3
				cc++
			default:
				panic(fmt.Sprintf("Invalid escape %c", s[i+1]))
			}
		} else {
			cc++
		}
	}
	return len(s) - cc + 2
}

func Part1(in []string) int {
	c := 0
	for _, l := range in {
		c += Count1(l)
	}
	return c
}

func Count2(s string) int {
	qc := 0
	for i := 0; i < len(s); i++ {
		switch s[i] {
		case '\\', '"':
			qc += 2
		default:
			qc++
		}
	}
	return 2 + qc - len(s)
}

func Part2(in []string) int {
	c := 0
	for _, l := range in {
		c += Count2(l)
	}
	return c
}

func main() {
	in := ReadInputLines()
	fmt.Printf("Part 1: %d\n", Part1(in))
	fmt.Printf("Part 2: %d\n", Part2(in))
}
