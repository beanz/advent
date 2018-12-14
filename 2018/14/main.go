package main

import (
	"fmt"
	"log"
	"os"
	"strings"

	. "github.com/beanz/advent-of-code-go"
)

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
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	g := NewGame(ReadLines(os.Args[1]))
	fmt.Printf("Part 1: %s\n", g.Part1())
	g = NewGame(ReadLines(os.Args[1]))
	fmt.Printf("Part 2: %d\n", g.Part2())
}
