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

func (g *Game) Part1() (int, bool) {
	ip := 0
	for {
		op := g.p[ip]
		ip++
		switch op {
		case 1:
			if ip+2 >= len(g.p) {
				return -1, false
			}
			i1, i2, o := g.p[ip], g.p[ip+1], g.p[ip+2]
			ip += 3
			g.p[o] = g.p[i1] + g.p[i2]
		case 2:
			if ip+2 >= len(g.p) {
				return -1, false
			}
			i1, i2, o := g.p[ip], g.p[ip+1], g.p[ip+2]
			ip += 3
			g.p[o] = g.p[i1] * g.p[i2]
		case 99:
			return g.p[0], true
		default:
			return -1, false
		}
		//fmt.Printf("%v\n", g.p)
	}
	return -1, false
}

func (g *Game) Part2() int {
	for input := 0; input <= 9999; input++ {
		prog := make([]int, len(g.p))
		copy(prog, g.p)
		prog[1] = input / 100
		prog[2] = input % 100
		res, valid := NewGame(prog).Part1()
		if valid == true && res == 19690720 {
			return input
		}
	}
	return -1
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	p := SimpleReadInts(lines[0])
	p[1] = 12
	p[2] = 2
	part1, _ := NewGame(p).Part1()
	fmt.Printf("Part 1: %d\n", part1)
	p = SimpleReadInts(lines[0])
	fmt.Printf("Part 2: %d\n", NewGame(p).Part2())
}