package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Cost(ax, ay, bx, by, px, py, add int) int {
	px += add
	py += add
	d := ax*by - ay*bx
	if d == 0 {
		return 0
	}
	x := (px*by - py*bx)
	m := x / d
	if m*d != x {
		return 0
	}
	x = py - ay*m
	n := x / by
	if n*by != x {
		return 0
	}
	return 3*m + n
}

func Parts(in []byte, args ...int) (int, int) {
	p1, p2 := 0, 0
	VisitNUints(in, []int{12, 4, 13, 4, 10, 4, 2}, func(n ...int) {
		p1 += Cost(n[0], n[1], n[2], n[3], n[4], n[5], 0)
		p2 += Cost(n[0], n[1], n[2], n[3], n[4], n[5], 10000000000000)
	})
	return p1, p2
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
