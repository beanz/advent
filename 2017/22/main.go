package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type NodeState byte

const (
	CLEAN    NodeState = 0
	INFECTED NodeState = '#'
	WEAKENED NodeState = 'W'
	FLAGGED  NodeState = 'F'
)

type Game struct {
	points []NodeState
	cur    Point
	dir    Direction
	count  int
	debug  bool
}

func (g *Game) String() string {
	s := ""
	ci := (g.cur.X + 255) + 512*(g.cur.Y+255)
	bb := NewBoundingBox()
	for y := -255; y <= 255; y++ {
		for x := -255; x <= 255; x++ {
			p := Point{x, y}
			if g.Get(p) != CLEAN {
				bb.Add(p)
			}
		}
	}
	for y := bb.Min.Y; y <= bb.Max.Y; y++ {
		for x := bb.Min.X; x <= bb.Max.X; x++ {
			i := (x + 255) + 512*(y+255)
			var sq string
			switch g.points[i] {
			case INFECTED:
				sq = "#"
			case WEAKENED:
				sq = "W"
			case FLAGGED:
				sq = "F"
			default:
				sq = "."
			}
			if i == ci {
				sq = Red(sq)
			}
			s += sq
		}
		s += "\n"
	}
	return s
}

func NewGame(lines []string) *Game {
	g := &Game{make([]NodeState, 512*512),
		Point{0, 0},
		Compass("N").Direction(),
		0,
		false}
	for y, line := range lines {
		for x, ch := range line {
			p := Point{x, y}
			if ch == '#' {
				g.Set(p, INFECTED)
			}
		}
	}
	g.cur = Point{len(lines[0]) / 2, len(lines) / 2}
	return g
}

func (g *Game) Get(p Point) NodeState {
	i := (p.X + 255) + 512*(p.Y+255)
	return g.points[i]
}

func (g *Game) Set(p Point, s NodeState) {
	i := (p.X + 255) + 512*(p.Y+255)
	g.points[i] = s
}

func (g *Game) Burst1() {
	infected := g.Get(g.cur) == INFECTED
	if infected {
		g.dir = g.dir.CW()
	} else {
		g.dir = g.dir.CCW()
	}
	if infected {
		g.Set(g.cur, CLEAN)
	} else {
		g.Set(g.cur, INFECTED)
		g.count++
	}
	g.cur = g.cur.In(g.dir)
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
	state := g.Get(g.cur)
	switch state {
	case WEAKENED:
		// no turn
		g.Set(g.cur, INFECTED)
		g.count++
	case INFECTED:
		g.dir = g.dir.CW()
		g.Set(g.cur, FLAGGED)
	case FLAGGED:
		g.dir = g.dir.CW().CW()
		g.Set(g.cur, CLEAN)
	default: // CLEAN
		g.dir = g.dir.CCW()
		g.Set(g.cur, WEAKENED)
	}
	g.cur = g.cur.In(g.dir)
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
	lines := InputLines(input)
	p1 := NewGame(lines).Part1(10000)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := NewGame(lines).Part2(10000000)
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
