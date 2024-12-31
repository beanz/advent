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
	VisitNInts(in, []int{2, 1, 3, 1, 1}, func(n ...int) {
		rs = append(rs, robot{n[0], n[1], n[2], n[3]})
	})
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
	p1 := q[0] * q[1] * q[2] * q[3]
	seen_back := [12000]uint16{}
	seen := NewReuseableSeen(seen_back[:])
	col := make([]int, 0, 10)
	row := make([]int, 0, 10)
	for d := 0; d < 103; d++ {
		cx := [101]int{}
		cy := [103]int{}
		for _, r := range rs {
			x, y := Mod(r.x+r.vx*d, w), Mod(r.y+r.vy*d, h)
			cx[x]++
			cy[y]++
		}
		c := 0
		for y := 0; y < 103; y++ {
			if cy[y] >= 31 {
				c++
			}
		}
		if c >= 2 {
			row = append(row, d)
		}
		if d >= 101 {
			continue
		}
		c = 0
		for x := 0; x < 101; x++ {
			if cx[x] >= 33 {
				c++
			}
		}
		if c >= 2 {
			col = append(col, d)
		}
	}
	if len(col) == 1 && len(row) == 1 {
		return p1, (5253*col[0] + 5151*row[0]) % 10403
	}

	for _, dc := range col {
	LOOP:
		for _, dr := range row {
			d := (5253*dc + 5151*dr) % 10403
			seen.Reset()
			for _, r := range rs {
				x, y := Mod(r.x+r.vx*d, w), Mod(r.y+r.vy*d, h)
				if seen.HaveSeen(x + y*w) {
					continue LOOP
				}
			}
			return p1, d
		}
	}
	return p1, 1
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
