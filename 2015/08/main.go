package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

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
	in := InputLines(input)
	p1 := Part1(in)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := Part2(in)
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark bool
