package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Group map[int]bool

type Groups struct {
	index  map[int]int
	next   int
	groups map[int]Group
	debug  bool
}

func NewGroups() *Groups {
	return &Groups{map[int]int{}, 0, map[int]Group{}, false}
}

func (g *Groups) String() string {
	s := ""
	for i, gg := range g.groups {
		s += fmt.Sprintf("%d: ", i)
		for k := range gg {
			s += fmt.Sprintf("%d ", k)
		}
		s += "\n"
	}
	for n, i := range g.index {
		s += fmt.Sprintf("%d => %d\n", n, i)
	}
	return s
}

func (g *Groups) Add(i, j int) {
	//fmt.Printf("Adding %d -> %d\n", i, j)
	gi, iOk := g.index[i]
	gj, jOk := g.index[j]

	switch {
	case iOk && jOk && gi != gj:
		//fmt.Printf("  Both groups exist i=%d is %d and j=%d is %d\n",
		//	i, gi, j, gj)
		for k := range g.groups[gj] {
			g.groups[gi][k] = true
			g.index[k] = gi
		}
		delete(g.groups, gj)
		g.index[j] = gi
	case iOk && !jOk:
		//fmt.Printf("  Group for i=%d is %d\n", i, gi)
		g.index[j] = gi
		g.groups[gi][j] = true
	case !iOk && jOk:
		//fmt.Printf("  Group for j=%d is %d\n", j, gj)
		g.index[i] = gj
		g.groups[gj][i] = true
	case !iOk && !jOk:
		g.index[i] = g.next
		g.groups[g.next] = Group{}
		g.next++
		g.index[j] = g.index[i]
		g.groups[g.index[i]][j] = true
		g.groups[g.index[j]][i] = true
	}
}

func Play(in []string) *Groups {
	g := NewGroups()
	for _, l := range in {
		ints := SimpleReadInts(l)
		for i := 1; i < len(ints); i++ {
			g.Add(ints[0], ints[i])
		}
	}
	return g
}

func (g *Groups) Part1() int {
	return len(g.groups[g.index[0]])
}

func (g *Groups) Part2() int {
	return len(g.groups)
}

func main() {
	g := Play(InputLines(input))
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
