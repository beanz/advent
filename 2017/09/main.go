package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	score := 0
	gc := 0
	level := 1
	for i := 0; i < len(in); {
		switch in[i] {
		case '<':
			i++
			for in[i] != '>' {
				if in[i] == '!' {
					i++
					gc--
				}
				i++
				gc++
			}
		case '{':
			score += level
			level++
		case '}':
			level--
		}
		i++
	}
	return score, gc
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
