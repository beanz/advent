package main

import (
	"fmt"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

type Dir [2]int

func (d *Dir) L() {
	d[0], d[1] = d[1], -1*d[0]
}

func (d *Dir) R() {
	d[0], d[1] = -1*d[1], d[0]
}

type Pos [2]int

func (p *Pos) ManhattanDistance() int {
	return Abs(p[0]) + Abs(p[1])
}

func Calc(in string) (int, int) {
	dir := Dir{0, -1}
	pos := Pos{0, 0}
	foundHQ := false
	var hq Pos
	seen := make(map[Pos]bool)
	for _, move := range strings.Split(in, ", ") {
		switch move[0] {
		case 'L':
			dir.L()
		case 'R':
			dir.R()
		}
		n := MustParseInt(move[1:])
		for i := 0; i < n; i++ {
			pos[0] += dir[0]
			pos[1] += dir[1]
			if !foundHQ && seen[pos] {
				foundHQ = true
				hq = Pos{pos[0], pos[1]}
			}
			seen[pos] = true
		}
		//fmt.Printf("%s => %d,%d\n", move, pos[0], pos[1])
	}
	return pos.ManhattanDistance(), hq.ManhattanDistance()
}

func main() {
	in := ReadInputLines()[0]
	p1, p2 := Calc(in)
	fmt.Printf("Part 1: %d\n", p1)
	fmt.Printf("Part 2: %d\n", p2)
}
