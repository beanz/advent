package main

import (
	"fmt"
	"log"
	//"math"
	"os"
	//"strings"

	. "github.com/beanz/advent/lib-go"
)

type Game struct {
	p     []int
	debug bool
}

func (g *Game) String() string {
	s := fmt.Sprintf("%d", len(g.p))
	return s
}

func NewGame(p []int) *Game {
	g := &Game{p, false}
	return g
}

func (g *Game) Part1() int {
	return 1
}

func (g *Game) Part2() int {
	return 2
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	p := SimpleReadInts(lines[0])
	fmt.Printf("Part 1: %d\n", NewGame(p).Part1())
	p = SimpleReadInts(lines[0])
	fmt.Printf("Part 2: %d\n", NewGame(p).Part2())
}
