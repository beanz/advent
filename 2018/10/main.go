package main

import (
	"fmt"
	"log"
	"os"

	. "github.com/beanz/advent/lib-go"
)

type Star struct {
	p Point
	v Point
}

type Game struct {
	stars []Star
	debug bool
}

func (g *Game) GetSize(t int) int {
	bb := NewBoundingBox()
	for _, s := range g.stars {
		bb.Add(Point{s.p.X + s.v.X*t, s.p.Y + s.v.Y*t})
	}
	return (bb.Max.X - bb.Min.X) * (bb.Max.Y - bb.Min.Y)
}

func (g *Game) GetState(t int) string {
	bb := NewBoundingBox()
	starMap := map[Point]bool{}
	for _, s := range g.stars {
		p := Point{s.p.X + s.v.X*t, s.p.Y + s.v.Y*t}
		bb.Add(p)
		starMap[p] = true
	}
	s := ""
	for y := bb.Min.Y; y <= bb.Max.Y; y++ {
		for x := bb.Min.X; x <= bb.Max.X; x++ {
			if starMap[Point{x, y}] {
				s += "#"
			} else {
				s += "."
			}
		}
		s += "\n"
	}

	return s
}

func (g *Game) Expanding(t int) bool {
	return g.GetSize(t) < g.GetSize(t+1)
}

func NewGame(lines []string) *Game {
	g := &Game{[]Star{}, false}
	for _, line := range lines {
		ints := SimpleReadInts(line)
		g.stars = append(g.stars,
			Star{Point{ints[0], ints[1]}, Point{ints[2], ints[3]}})
	}
	return g
}

func (g *Game) Solve() (string, int) {
	upper := 1
	for !g.Expanding(upper) {
		upper *= 2
	}
	lower := 1
	for (upper - lower) > 3 {
		t := (upper + lower) / 2
		if g.Expanding(t) {
			upper = t
		} else {
			lower = t
		}
	}
	minSize := 1000000
	minT := 0
	for t := lower; t <= upper; t++ {
		size := g.GetSize(t)
		if size < minSize {
			minSize = size
			minT = t
		}
	}
	return g.GetState(minT), minT
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	g := NewGame(ReadLines(os.Args[1]))
	s, t := g.Solve()
	fmt.Printf("Part 1:\n%s\n", s)
	fmt.Printf("Part 2: %d\n", t)
}
