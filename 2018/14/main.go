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
	si      int
	end     []byte
}

func (r *RecipeState) len() int {
	return len(r.recipes)
}

func (r *RecipeState) next() {
	v0 := r.recipes[r.e0]
	v1 := r.recipes[r.e1]
	n := v0 + v1
	if n >= 10 {
		r.recipes = append(r.recipes, n/10)
	}
	r.recipes = append(r.recipes, n%10)
	r.e0 = (r.e0 + int(v0) + 1) % len(r.recipes)
	r.e1 = (r.e1 + int(v1) + 1) % len(r.recipes)
}

func (r *RecipeState) hasEnd() int {
SEARCH:
	for ; r.si < len(r.recipes)-len(r.end); r.si++ {
		for j := 0; j < len(r.end); j++ {
			if r.recipes[r.si+j] != r.end[j] {
				continue SEARCH
			}
		}
		return r.si
	}
	return -1
}

type Game struct {
	endString []byte
	end       int
	init      []byte
	debug     bool
}

func NewGame(lines []string) *Game {
	g := &Game{[]byte(lines[0]), SimpleReadInts(lines[0])[0],
		[]byte("37"), false}
	return g
}

func (g *Game) Part1() string {
	state := make([]byte, len(g.init), g.end+10)
	for i := 0; i < len(g.init); i++ {
		state[i] = g.init[i] - '0'
	}
	s := RecipeState{state, 0, 1, 0, []byte{}}
	for {
		s.next()
		if s.len() >= g.end+10 {
			break
		}
	}
	var sb strings.Builder
	for _, v := range s.recipes[g.end : g.end+10] {
		sb.WriteByte('0' + v)
	}
	return sb.String()
}

func (g *Game) Part2() int {
	state := make([]byte, len(g.init), 20480000)
	for i := 0; i < len(g.init); i++ {
		state[i] = g.init[i] - '0'
	}
	end := make([]byte, len(g.endString))
	for i := 0; i < len(g.endString); i++ {
		end[i] = g.endString[i] - '0'
	}
	s := RecipeState{state, 0, 1, 0, end}
	i := -1
	for s.len() < 30000000 {
		s.next()
		if i = s.hasEnd(); i != -1 {
			break
		}
	}
	return i
}

func main() {
	g := NewGame(InputLines(input))
	p1 := g.Part1()
	p2 := g.Part2()
	if !benchmark {
		fmt.Printf("Part1: %s\n", p1)
		fmt.Printf("Part2: %d\n", p2)
	}
}

var benchmark = false
