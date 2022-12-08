package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Game struct {
	m ByteMap
}

func NewGame(in []byte) *Game {
	return &Game{*NewByteMap(in)}
}

func (g *Game) Part1() int {
	c := 0
	w := g.m.Width()
	h := g.m.Height()
	g.m.Visit(func(i int, v byte) (byte, bool) {
		x, y := g.m.IndexToXY(i)
		for _, o := range [][]int{{-1, 0}, {0, -1}, {1, 0}, {0, 1}} {
			nx, ny := x+o[0], y+o[1]
			visible := true
			for nx >= 0 && ny >= 0 && nx < w && ny < h {
				if g.m.GetXY(nx, ny) >= v {
					visible = false
					break
				}
				nx, ny = nx+o[0], ny+o[1]
			}
			if visible {
				c++
				return 0, false
			}
		}
		return 0, false
	})
	return c
}

func (g *Game) Part2() int {
	max := 0
	w := g.m.Width()
	h := g.m.Height()
	g.m.Visit(func(i int, v byte) (byte, bool) {
		x, y := g.m.IndexToXY(i)
		s := 1
		for _, o := range [][]int{{-1, 0}, {0, -1}, {1, 0}, {0, 1}} {
			nx, ny := x+o[0], y+o[1]
			c := 0
			for nx >= 0 && ny >= 0 && nx < w && ny < h {
				c++
				if g.m.GetXY(nx, ny) >= v {
					break
				}
				nx, ny = nx+o[0], ny+o[1]
			}
			s *= c
			if s == 0 {
				return 0, false
			}
		}
		if s > max {
			max = s
		}
		return 0, false
	})
	return max
}

func main() {
	g := NewGame(InputBytes(input))
	p1 := g.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := g.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
