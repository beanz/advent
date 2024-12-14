package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type robot struct {
	x, y, vx, vy int
}

func Parts(in []byte, args ...int) (int, int) {
	rs := make([]robot, 0, 500)
	for i := 0; i < len(in); {
		var j, x, y, vx, vy int
		j, x = ChompInt[int](in, i+2)
		j, y = ChompInt[int](in, j+1)
		j, vx = ChompInt[int](in, j+3)
		j, vy = ChompInt[int](in, j+1)
		i = j + 1
		rs = append(rs, robot{x, y, vx, vy})
	}
	w, h := 101, 103
	if len(rs) <= 12 {
		w, h = 11, 7
	}
	qw, qh := w/2, h/2
	q := [4]int{0, 0, 0, 0}
	d := 100
	for _, r := range rs {
		x, y := Mod(r.x+r.vx*d, w), Mod(r.y+r.vy*d, h)
		qi := 0
		if x > qw {
			qi += 1
		}
		if y > qh {
			qi += 2
		}
		if x != qw && y != qh {
			q[qi]++
		}
	}
	p1, p2 := q[0]*q[1]*q[2]*q[3], 0
LOOP:
	for d := 1; d < 10000; d++ {
		seen := [12000]bool{}
		for _, r := range rs {
			x, y := Mod(r.x+r.vx*d, w), Mod(r.y+r.vy*d, h)
			if seen[x+y*w] {
				continue LOOP
			}
			seen[x+y*w] = true
		}
		p2 = d
		break
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
