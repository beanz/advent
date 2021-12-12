package main

import (
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Cave struct {
	g map[string][]string
}

func NewCave(in []byte) *Cave {
	// 16 seems small but only 12 in my input
	neighbors := make(map[string][]string, 16)
	var start, dash int
	for i, ch := range in {
		switch ch {
		case '-':
			dash = i
		case '\n':
			st, end := string(in[start:dash]), string(in[dash+1:i])
			if end != "start" {
				neighbors[st] = append(neighbors[st], end)
			}
			if st != "start" {
				neighbors[end] = append(neighbors[end], st)
			}
			start = i + 1
		}
	}
	return &Cave{neighbors}
}

func (c *Cave) Solve(start, end string, seen map[string]bool, p2 bool, twice bool) int {
	if start == end {
		return 1
	}
	if start[0] >= 'a' && start[0] <= 'z' {
		seen[start] = true
	}
	paths := 0
	for _, nb := range c.g[start] {
		ntwice := twice
		if seen[nb] {
			if !p2 || twice {
				continue
			}
			ntwice = true
		}
		nseen := make(map[string]bool, len(seen)+4)
		for k := range seen {
			nseen[k] = true
		}
		paths += c.Solve(nb, end, nseen, p2, ntwice)
	}
	return paths
}

func (c *Cave) Part1() int {
	return c.Solve("start", "end", make(map[string]bool), false, false)
}

func (c *Cave) Part2() int {
	return c.Solve("start", "end", make(map[string]bool), true, false)
}

func main() {
	g := NewCave(InputBytes(input))
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
