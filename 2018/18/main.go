package main

import (
	"fmt"
	"log"
	"os"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

type Game struct {
	m     []string
	bb    *BoundingBox
	debug bool
}

func (g *Game) String() string {
	s := ""
	for _, line := range g.m {
		s += line + "\n"
	}
	return s
}

func NewGame(lines []string) *Game {
	g := &Game{lines, NewBoundingBox(), false}
	g.bb.Add(Point{0, 0})
	g.bb.Add(Point{len(lines[0]) - 1, len(lines) - 1})
	return g
}

func (g *Game) Count(fn func(byte) bool) int {
	c := 0
	for y := g.bb.Min.Y; y <= g.bb.Max.Y; y++ {
		for x := g.bb.Min.X; x <= g.bb.Max.X; x++ {
			if fn(g.m[y][x]) {
				c++
			}
		}
	}
	return c
}

func (g *Game) neighbourCounts(p Point) (int, int) {
	trees, lumber := 0, 0
	for _, np := range p.Neighbours8() {
		if !g.bb.Contains(np) {
			continue
		}
		switch g.m[np.Y][np.X] {
		case '|':
			trees++
		case '#':
			lumber++
		}
	}
	return trees, lumber
}

func (g *Game) iter() {
	n := []string{}
	for y := g.bb.Min.Y; y <= g.bb.Max.Y; y++ {
		var row strings.Builder
		for x := g.bb.Min.X; x <= g.bb.Max.X; x++ {
			p := Point{x, y}
			trees, lumber := g.neighbourCounts(p)
			var v byte
			switch g.m[p.Y][p.X] {
			case '.':
				if trees >= 3 {
					v = '|'
				} else {
					v = '.'
				}
			case '|':
				if lumber >= 3 {
					v = '#'
				} else {
					v = '|'
				}
			default:
				if trees >= 1 && lumber >= 1 {
					v = '#'
				} else {
					v = '.'
				}
			}
			row.WriteByte(v)
		}
		n = append(n, row.String())
	}
	g.m = n
}

func (g *Game) Value() int {
	return g.Count(func(b byte) bool {
		return b == '|'
	}) * g.Count(func(b byte) bool {
		return b == '#'
	})
}

func (g *Game) Part1() int {
	for i := 0; i < 10; i++ {
		g.iter()
	}
	return g.Value()
}

func (g *Game) Part2() int {
	minutes := 1000000000
	var i int
	for i = 0; i < 300; i++ {
		g.iter()
	}

	seen := map[int]int{}
	for i < minutes {
		g.iter()
		i++
		v := g.Value()
		if g.debug {
			fmt.Printf("Iter: %d %d\n", i, v)
		}
		if pi, ok := seen[v]; ok {
			cycle := i - pi
			remaining := minutes - i
			inc := cycle * (remaining / cycle)
			if g.debug {
				fmt.Printf("Cycle found %d at %d and %d\n"+
					"Cycle length %d\n"+
					"Remaining steps: %d - %d = %d\n"+
					"Incrementing iteration by %d\n",
					v, pi, i,
					cycle,
					minutes, i, remaining,
					inc)
			}
			i += inc
			seen = map[int]int{}
		} else {
			seen[v] = i
		}
	}
	return g.Value()
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	g := NewGame(ReadLines(os.Args[1]))
	fmt.Printf("Part 1: %d\n", g.Part1())
	g = NewGame(ReadLines(os.Args[1]))
	fmt.Printf("Part 2: %d\n", g.Part2())
}
