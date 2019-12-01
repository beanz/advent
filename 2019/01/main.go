package main

import (
	"fmt"
	"log"
	//"math"
	"os"
	//"strings"

	. "github.com/beanz/advent-of-code-go"
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
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	mass, _ := ReadInts(ReadLines(os.Args[1]))
	fmt.Printf("Part 1: %d\n", NewGame(mass).Part1())
	fmt.Printf("Part 2: %d\n", NewGame(mass).Part2())
}
