package main

import (
	"fmt"
	"log"
	"os"

	. "github.com/beanz/advent-of-code-go"
)

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
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	g := Play(ReadLines(os.Args[1]))
	fmt.Printf("Part 1: %d\n", g.Part1())
	fmt.Printf("Part 2: %d\n", g.Part2())
}
