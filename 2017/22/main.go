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
	points     []NodeState
	cur        int
	dirX, dirY int
	count      int
}

func (g *Game) String() string {
	s := ""
	bb := NewFBoundingBox()
	for y := -255; y <= 255; y++ {
		for x := -255; x <= 255; x++ {
			p := g.Index(x, y)
			if g.points[p] != CLEAN {
				bb.AddXY(int32(x), int32(y))
			}
		}
	}
	xmin, xmax, ymin, ymax := bb.Limits()
	for y := ymin; y <= ymax; y++ {
		for x := xmin; x <= xmax; x++ {
			i := int((x + 255) + 512*(y+255))
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
			if i == g.cur {
				sq = Red(sq)
			}
			s += sq
		}
		s += "\n"
	}
	return s
}

func NewGame(lines []string) *Game {
	g := &Game{make([]NodeState, 512*512), 0, 0, -1, 0}
	g.cur = g.Index(len(lines[0])/2, len(lines)/2)
	for y, line := range lines {
		for x, ch := range line {
			if ch == '#' {
				g.points[g.Index(x, y)] = INFECTED
			}
		}
	}
	return g
}

func (g *Game) Index(x, y int) int {
	return (x + 255) + 512*(y+255)
}

func (g *Game) Burst1() {
	infected := g.points[g.cur] == INFECTED
	if infected {
		g.dirX, g.dirY = -g.dirY, g.dirX
	} else {
		g.dirX, g.dirY = g.dirY, -g.dirX
	}
	if infected {
		g.points[g.cur] = CLEAN
	} else {
		g.points[g.cur] = INFECTED
		g.count++
	}
	g.cur += g.dirX + 512*g.dirY
}

func (g *Game) Part1(bursts int) int {
	for i := 0; i < bursts; i++ {
		g.Burst1()
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
		g.dirX, g.dirY = -g.dirY, g.dirX
		g.points[g.cur] = FLAGGED
	case FLAGGED:
		g.dirX, g.dirY = -g.dirX, -g.dirY
		g.points[g.cur] = CLEAN
	default: // CLEAN
		g.dirX, g.dirY = g.dirY, -g.dirX
		g.points[g.cur] = WEAKENED
	}
	g.cur += g.dirX + 512*g.dirY
}

func (g *Game) Part2(bursts int) int {
	for i := 0; i < bursts; i++ {
		g.Burst2()
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
