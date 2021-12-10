package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Claim struct {
	id   int
	p    Point
	w, h int
}

type Game struct {
	claims []Claim
	debug  bool
}

func NewGame(lines []string) *Game {
	g := &Game{[]Claim{}, false}
	for _, line := range lines {
		ints := SimpleReadInts(line)
		g.claims = append(g.claims,
			Claim{ints[0], Point{ints[1], ints[2]}, ints[3], ints[4]})
	}
	return g
}

func mapClaims(claims []Claim) (map[Point]int, int) {
	m := make(map[Point]int)
	c := 0

	for _, claim := range claims {
		for i := 0; i < claim.w; i++ {
			for j := 0; j < claim.h; j++ {
				p := Point{claim.p.X + i, claim.p.Y + j}
				if m[p] == 1 {
					c++
				}
				m[p]++
			}
		}
	}
	return m, c
}

func (g *Game) Part1() int {
	_, c := mapClaims(g.claims)
	return c
}

func (g *Game) Part2() int {
	m, _ := mapClaims(g.claims)

	for _, claim := range g.claims {
		unique := true
		for i := 0; i < claim.w; i++ {
			for j := 0; j < claim.h; j++ {
				p := Point{claim.p.X + i, claim.p.Y + j}
				if m[p] != 1 {
					unique = false
					break
				}
			}
		}
		if unique {
			return claim.id
		}
	}
	return -1
}

func main() {
	g := NewGame(InputLines(input))
	p1 := g.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := g.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
