package main

import (
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

type NodeState byte

const (
	CLEAN    NodeState = 0
	INFECTED NodeState = '#'
	WEAKENED NodeState = 'W'
	FLAGGED  NodeState = 'F'
)

type Game struct {
	points map[Point]NodeState
	bb     *BoundingBox
	cur    Point
	dir    Direction
	count  int
	debug  bool
}

func (g *Game) String() string {
	s := ""
	for y := g.bb.Min.Y; y <= g.bb.Max.Y; y++ {
		for x := g.bb.Min.X; x <= g.bb.Max.X; x++ {
			p := Point{x, y}
			var sq string
			switch g.points[p] {
			case INFECTED:
				sq = "#"
			case WEAKENED:
				sq = "W"
			case FLAGGED:
				sq = "F"
			default:
				sq = "."
			}
			if p == g.cur {
				sq = Red(sq)
			}
			s += sq
		}
		s += "\n"
	}
	return s
}

func NewGame(lines []string) *Game {
	g := &Game{map[Point]NodeState{},
		NewBoundingBox(),
		Point{0, 0},
		Compass("N").Direction(),
		0,
		false}
	for y, line := range lines {
		for x, ch := range line {
			p := Point{x, y}
			g.bb.Add(p)
			if ch == '#' {
				g.points[p] = INFECTED
			}
		}
	}
	g.cur = Point{(g.bb.Max.X + g.bb.Min.X) / 2, (g.bb.Max.Y + g.bb.Min.Y) / 2}
	return g
}

func (g *Game) Burst1() {
	infected := g.points[g.cur] == INFECTED
	if infected {
		g.dir = g.dir.CW()
	} else {
		g.dir = g.dir.CCW()
	}
	if infected {
		delete(g.points, g.cur)
	} else {
		g.points[g.cur] = INFECTED
		g.count++
	}
	g.cur = g.cur.In(g.dir)
	g.bb.Add(g.cur)
}

func (g *Game) Part1(bursts int) int {
	for i := 0; i < bursts; i++ {
		g.Burst1()
		if g.debug {
			fmt.Printf("%s\n", g)
		}
	}
	return g.count
}

func (g *Game) Burst2() {
	state := g.points[g.cur]
	switch state {
	case WEAKENED:
		// no turn
		g.points[g.cur] = INFECTED
		g.count++
	case INFECTED:
		g.dir = g.dir.CW()
		g.points[g.cur] = FLAGGED
	case FLAGGED:
		g.dir = g.dir.CW().CW()
		delete(g.points, g.cur)
	default: // CLEAN
		g.dir = g.dir.CCW()
		g.points[g.cur] = WEAKENED
	}
	g.cur = g.cur.In(g.dir)
	g.bb.Add(g.cur)
}

func (g *Game) Part2(bursts int) int {
	for i := 0; i < bursts; i++ {
		g.Burst2()
		if g.debug {
			fmt.Printf("%s\n", g)
		}
	}
	return g.count
}

func main() {
	lines := ReadInputLines()
	fmt.Printf("Part 1: %d\n", NewGame(lines).Part1(10000))
	fmt.Printf("Part 2: %d\n", NewGame(lines).Part2(10000000))
}
