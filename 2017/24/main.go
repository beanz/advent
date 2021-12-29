package main

import (
	_ "embed"
	"fmt"
	"sort"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Component struct {
	in, out uint16
}

func (c Component) String() string {
	return fmt.Sprintf("%d/%d", c.in, c.out)
}

type ComponentUsed uint64

func (cu ComponentUsed) Add(i int) ComponentUsed {
	return cu | (1 << i)
}

func (cu ComponentUsed) Used(i int) bool {
	return cu&(1<<i) != 0
}

type sortComponents []Component

func (c sortComponents) Less(i, j int) bool {
	return (c[i].in + c[i].out) > (c[j].in + c[j].out)
}

func (c sortComponents) Swap(i, j int) {
	c[i], c[j] = c[j], c[i]
}

func (c sortComponents) Len() int {
	return len(c)
}

type Game struct {
	comp []Component
}

func (g *Game) String() string {
	s := ""
	for _, c := range g.comp {
		s += fmt.Sprintf("%s\n", c)
	}
	return s
}

func NewGame(in []byte) *Game {
	ints := FastInts(in, 128)
	c := make([]Component, 0, len(ints)/2)
	for i := 0; i < len(ints); i += 2 {
		c = append(c, Component{uint16(ints[i]), uint16(ints[i+1])})
	}
	sort.Sort(sortComponents(c))
	return &Game{c}
}

type Search struct {
	used  ComponentUsed
	len   uint16
	score uint16
	port  uint16
}

func String(cs []Component) string {
	s := ""
	for _, c := range cs {
		s += fmt.Sprintf("%s ", c)
	}
	return s
}

func (g *Game) Play() (uint16, uint16) {
	todo := make([]Search, 1, 90000)
	todo[0] = Search{ComponentUsed(0), 0, 0, 0}
	var best uint16
	var longest uint16
	var longestLen uint16
	for len(todo) > 0 {
		cur := todo[0]
		todo = todo[1:]
		if cur.score > best {
			best = cur.score
		}
		if cur.len > longestLen ||
			(cur.len == longestLen && cur.score > longest) {
			longest = cur.score
			longestLen = cur.len
		}
		for i, c := range g.comp {
			if cur.used.Used(i) {
				continue
			}
			switch cur.port {
			case c.in:
				nused := cur.used.Add(i)
				new := Search{
					nused, cur.len + 1, cur.score + c.in + c.out, c.out}
				todo = append(todo, new)
			case c.out:
				nused := cur.used.Add(i)
				new := Search{
					nused, cur.len + 1, cur.score + c.in + c.out, c.in}
				todo = append(todo, new)
			}
		}
	}
	return best, longest
}

func main() {
	best, longest := NewGame(InputBytes(input)).Play()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", best)
		fmt.Printf("Part 2: %d\n", longest)
	}
}

var benchmark = false
