package main

import (
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

type Board struct {
	b [][]int
	score int
	won bool
	num int
	rleft []int
	cleft []int
}

type NumLocation struct {
	b, r, c int
}

type Diag struct {
	pp []*PointPair
	debug bool
}

func NewDiag(in []*PointPair) *Diag {
	return &Diag{in, false}
}

func (d *Diag) Overlaps() (int, int) {
	d1 := make(map[Point]int)
	d2 := make(map[Point]int)
	c1 := 0
	c2 := 0
	for _, pp := range d.pp {
		n := pp.Norm()
		var lineLen = MaxInt(Abs(pp.P1.X - pp.P2.X), Abs(pp.P1.Y - pp.P2.Y))
		x := pp.P1.X
		y := pp.P1.Y
		for i := 0; i <= lineLen; i++ {
			p := Point{x,y}
			if n.X == 0 || n.Y == 0 {
				d1[p]++
				if d1[p] == 2 {
					c1++
				}
			}
			d2[p]++
			if d2[p] == 2 {
				c2++
			}
			x += n.X
			y += n.Y
		}
	}
	return c1, c2
}

func main() {
	inp := ReadInputPointPairs()
	d := NewDiag(inp)
	p1, p2 := d.Overlaps()
	fmt.Printf("Part 1: %d\n", p1)
	fmt.Printf("Part 2: %d\n", p2)
}
