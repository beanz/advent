package main

import (
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Game struct {
	i int
}

func NewGame(in []byte) *Game {
	return &Game{1}
}

func (g *Game) Part1() int {
	return g.i
}

func (g *Game) Part2() int {
	return g.i
}

func main() {
	g := NewGame(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", g.Part1())
		fmt.Printf("Part 2: %d\n", g.Part2())
	}
}

var benchmark = false
