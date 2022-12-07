package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type parseState struct {
	e []int
	i int
}

type Game struct {
	p     parseState
	debug bool
}

func (p *parseState) next() int {
	v := p.e[p.i]
	p.i++
	return v
}

func NewGame(lines []string) *Game {
	g := &Game{parseState{SimpleReadInts(lines[0]), 0}, false}
	return g
}

func (p *parseState) Part1Parse() int {
	s := 0
	c := p.next()
	m := p.next()
	for j := 0; j < c; j++ {
		s += p.Part1Parse()
	}
	for j := 0; j < m; j++ {
		s += p.next()
	}
	return s
}

func (g *Game) Part1() int {
	return g.p.Part1Parse()
}

func (p *parseState) Part2Parse() int {
	s := 0
	c := p.next()
	m := p.next()
	if c > 0 {
		cc := make([]int, 0, c)
		for j := 0; j < c; j++ {
			cc = append(cc, p.Part2Parse())
		}
		for j := 0; j < m; j++ {
			me := p.next()
			if me <= len(cc) {
				s += cc[me-1]
			}
		}
	} else {
		for j := 0; j < m; j++ {
			s += p.next()
		}
	}
	return s
}

func (g *Game) Part2() int {
	return g.p.Part2Parse()
}

func main() {
	g := NewGame(InputLines(input))
	p1 := g.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	g = NewGame(InputLines(input))
	p2 := g.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
