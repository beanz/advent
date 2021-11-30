package main

import (
	"fmt"
	"log"
	"os"

	. "github.com/beanz/advent/lib-go"
)

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
	cc := []int{}
	if c > 0 {
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
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	g := NewGame(ReadLines(os.Args[1]))
	fmt.Printf("Part 1: %d\n", g.Part1())
	g = NewGame(ReadLines(os.Args[1]))
	fmt.Printf("Part 2: %d\n", g.Part2())
}
