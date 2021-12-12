package main

import (
	_ "embed"
	"fmt"
	"math"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(b []byte) (int, int) {
	max := math.MinInt64
	p := NewHexPoint(0, 0)
	var p1 int
	step := make([]byte, 0, 2)
	for _, ch := range b {
		switch ch {
		case ',', '\n':
			p.Move(string(step))
			p1 = p.Distance(NewHexPoint(0, 0))
			if p1 > max {
				max = p1
			}
			step = step[:0]
		default:
			step = append(step, ch)
		}
	}
	if len(step) != 0 {
		p.Move(string(step))
		p1 = p.Distance(NewHexPoint(0, 0))
		if p1 > max {
			max = p1
		}
	}
	return p1, max
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
