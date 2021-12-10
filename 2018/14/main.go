package main

import (
	_ "embed"
	"fmt"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type RecipeState struct {
	recipes []byte
	e0, e1  int
}

func (r *RecipeState) len() int {
	return len(r.recipes)
}

func (r *RecipeState) next() {
	v0 := r.recipes[r.e0] - '0'
	v1 := r.recipes[r.e1] - '0'
	s := fmt.Sprintf("%d", v0+v1)
	for _, e := range s {
		r.recipes = append(r.recipes, byte(e))
	}
	r.e0 = (r.e0 + int(v0) + 1) % len(r.recipes)
	r.e1 = (r.e1 + int(v1) + 1) % len(r.recipes)
}

func (r *RecipeState) contains(s string) int {
	return strings.Index(string(r.recipes), s)
}

type Game struct {
	endString string
	end       int
	init      []byte
	debug     bool
}

func NewGame(lines []string) *Game {
	g := &Game{lines[1], SimpleReadInts(lines[1])[0], []byte{}, false}
	for _, e := range lines[0] {
		g.init = append(g.init, byte(e))
	}
	return g
}

func (g *Game) Part1() string {
	s := RecipeState{g.init, 0, 1}
	for {
		s.next()
		if s.len() >= g.end+10 {
			break
		}
	}
	return fmt.Sprintf("%s", s.recipes[g.end:g.end+10])
}

func (g *Game) Part2() int {
	s := RecipeState{g.init, 0, 1}
	i := -1
	for {
		s.next()
		if s.len()%100000 == 0 {
			if i = s.contains(g.endString); i != -1 {
				break
			}
		}
	}
	return i
}

func main() {
	g := NewGame(InputLines(input))
	p1 := g.Part1()
	if !benchmark {
		fmt.Printf("Part1: %s\n", p1)
	}
	g = NewGame(InputLines(input))
	p2 := g.Part2()
	if !benchmark {
		fmt.Printf("Part2: %d\n", p2)
	}
}

var benchmark = false
