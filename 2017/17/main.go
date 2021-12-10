package main

import (
	_ "embed"
	"fmt"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Game struct {
	state *Circle
	steps int
	debug bool
}

func (g *Game) String() string {
	t := g.state
	for t.Num != 0 {
		t = t.Cw
	}
	s := []string{}
	for {
		if t == g.state {
			s = append(s, fmt.Sprintf("(%d)", t.Num))
		} else {
			s = append(s, fmt.Sprintf(" %d ", t.Num))
		}
		t = t.Cw
		if t.Num == 0 {
			break
		}
	}
	return strings.Join(s, " ")
}

func NewGame(steps int) *Game {
	g := &Game{nil, steps, false}
	g.state = NewCircle(0)
	return g
}

func (g *Game) Part1(nums int) int {
	if g.debug {
		fmt.Printf("%s\n", g)
	}
	for i := 1; i <= nums; i++ {
		for j := 0; j < g.steps; j++ {
			g.state = g.state.Cw
		}
		g.state = g.state.AddNew(i)
		if g.debug {
			fmt.Printf("%s\n", g)
		}
	}
	return g.state.Cw.Num
}

func (g *Game) Part2Brute() int {
	g.Part1(50000000)
	t := g.state
	for t.Num != 0 {
		t = t.Cw
	}
	return t.Cw.Num
}

func (g *Game) Part2() int {
	cur := 0
	ans := -1
	for i := 1; i <= 50000000; i++ {
		cur = (cur + g.steps) % i
		if cur == 0 {
			ans = i
		}
		cur++
	}
	return ans
}

func main() {
	steps := InputInts(input)[0]
	p1 := NewGame(steps).Part1(2017)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := NewGame(steps).Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
