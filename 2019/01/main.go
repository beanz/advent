package main

import (
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

type Game struct {
	mass  []int
	debug bool
}

func (g *Game) String() string {
	s := fmt.Sprintf("%d", len(g.mass))
	return s
}

func NewGame(mass []int) *Game {
	g := &Game{mass, false}
	return g
}

func (g *Game) Part1() int {
	s := 0
	for _, m := range g.mass {
		f := fuel(m)
		s += f
	}
	return s
}

func fuel(m int) int {
	return m/3 - 2
}

func (g *Game) Part2() int {
	s := 0
	for _, m := range g.mass {
		for {
			f := fuel(m)
			if f <= 0 {
				break
			}
			s += f
			m = f
		}
	}
	return s
}

func main() {
	mass := ReadInts(ReadInputLines())
	fmt.Printf("Part 1: %d\n", NewGame(mass).Part1())
	fmt.Printf("Part 2: %d\n", NewGame(mass).Part2())
}
