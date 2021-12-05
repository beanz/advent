package main

import (
	"fmt"
	. "github.com/beanz/advent/lib-go"
)

type Game struct {
	i int
}

func NewGame(in []string) *Game {
	return &Game{1}
}

func (g *Game) Part1() int {
	return g.i
}

func (g *Game) Part2() int {
	return g.i
}

func main() {
	inp := ReadInputLines()
	g := NewGame(inp)
	fmt.Printf("Part 1: %d\n", g.Part1())
	fmt.Printf("Part 2: %d\n", g.Part2())
}
