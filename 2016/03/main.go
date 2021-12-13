package main

import (
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Game struct {
	i []int
}

func NewGame(in []byte) *Game {
	return &Game{FastInts(in, 6000)}
}

func (g *Game) Part1() int {
	c := 0
	for i := 0; i < len(g.i); i += 3 {
		if g.i[i] + g.i[i+1] > g.i[i+2] && g.i[i] + g.i[i+2] > g.i[i+1] && g.i[i+1] + g.i[i+2] > g.i[i] {
			c++
		}
	}
	return c
}

func (g *Game) Part2() int {
	c := 0
	for i := 0; i < len(g.i); i += 7 {
		if g.i[i] + g.i[i+3] > g.i[i+6] && g.i[i] + g.i[i+6] > g.i[i+3] && g.i[i+3] + g.i[i+6] > g.i[i] {
			c++
		}
		i++
		if g.i[i] + g.i[i+3] > g.i[i+6] && g.i[i] + g.i[i+6] > g.i[i+3] && g.i[i+3] + g.i[i+6] > g.i[i] {
			c++
		}
		i++
		if g.i[i] + g.i[i+3] > g.i[i+6] && g.i[i] + g.i[i+6] > g.i[i+3] && g.i[i+3] + g.i[i+6] > g.i[i] {
			c++
		}
	}
	return c
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
