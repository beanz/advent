package main

import (
	"fmt"
	"log"
	"math"
	"os"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

type Game struct {
	orbits map[string]string
	cache  map[string]map[string]int
	debug  bool
}

func (g *Game) String() string {
	s := fmt.Sprintf("%d", len(g.orbits))
	return s
}

func NewGame(lines []string) *Game {
	o := make(map[string]string)
	for _, line := range lines {
		sp := strings.Split(line, ")")
		o[sp[1]] = sp[0]
	}
	g := &Game{o, make(map[string]map[string]int), false}
	return g
}

func (g *Game) parents(obj string) map[string]int {
	if v, ok := g.cache[obj]; ok {
		return v
	}
	p := make(map[string]int)
	if _, ok := g.orbits[obj]; !ok {
		g.cache[obj] = p
		return p
	}
	parent := g.orbits[obj]
	p[parent] = 0

	for grand, dist := range g.parents(parent) {
		p[grand] = dist + 1
	}
	g.cache[obj] = p
	return p
}

func (g *Game) Part1() int {
	s := 0
	for obj := range g.orbits {
		v := len(g.parents(obj))
		s += v
	}
	return s
}

func (g *Game) Part2() int {
	p1 := g.parents("YOU")
	p2 := g.parents("SAN")
	min := math.MaxInt64
	for p, d1 := range p1 {
		if d2, ok := p2[p]; ok {
			d := d1 + d2
			if min > d {
				min = d
			}
		}
	}
	return min
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	fmt.Printf("Part 1: %d\n", NewGame(lines).Part1())
	fmt.Printf("Part 2: %d\n", NewGame(lines).Part2())
}
