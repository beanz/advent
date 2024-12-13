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
	for i := 0; i < len(in); i++ {
		var j, ax, ay, bx, by, px, py int
		j, ax = ChompUInt[int](in, i+12)
		j, ay = ChompUInt[int](in, j+4)
		j, bx = ChompUInt[int](in, j+13)
		j, by = ChompUInt[int](in, j+4)
		j, px = ChompUInt[int](in, j+10)
		j, py = ChompUInt[int](in, j+4)
		i = j + 1
		p1 += Cost(ax, ay, bx, by, px, py, 0)
		p2 += Cost(ax, ay, bx, by, px, py, 10000000000000)
	}

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
