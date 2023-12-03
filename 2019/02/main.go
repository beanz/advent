package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

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
	}
}

func (g *Game) Part2() int {
	for input := 0; input <= 9999; input++ {
		prog := make([]int, len(g.p))
		copy(prog, g.p)
		prog[1] = input / 100
		prog[2] = input % 100
		res, valid := NewGame(prog).Part1()
		if valid && res == 19690720 {
			return input
		}
	}
	return -1
}

func main() {
	lines := InputLines(input)
	p := SimpleReadInts(lines[0])
	p[1] = 12
	p[2] = 2
	part1, _ := NewGame(p).Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", part1)
	}
	p = SimpleReadInts(lines[0])
	part2 := NewGame(p).Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", part2)
	}
}

var benchmark = false
