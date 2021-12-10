package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

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

func NewDiag(in []string) *Diag {
	pp := make([]*PointPair, len(in))
	for i, l := range in {
		ints := Ints(l)
		pp[i] = &PointPair{
			P1: &Point{X: ints[0], Y: ints[1]},
			P2: &Point{X: ints[2], Y: ints[3]},
		}
	}
	return &Diag{pp, false}
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
	inp := InputLines(input)
	d := NewDiag(inp)
	p1, p2 := d.Overlaps()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
