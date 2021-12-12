package main

import (
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Cave int

const (
	START Cave = 0x7374617274
	END        = 0x656e64
)

func (c Cave) String() string {
	s := ""
	i := int(c)
	for i > 0 {
		s = string(byte(i&0xff)) + s
		i >>= 8
	}
	return s
}

func (c *Cave) HashKey() int {
	return int(*c)
}

type CaveSystem struct {
	g map[Cave][]Cave
}

func NewCaveSystem(in []byte) *CaveSystem {
	// 16 seems small but only 12 in my input
	neighbors := make(map[Cave][]Cave, 16)
	var start, end int
	var foundDash bool
	for _, ch := range in {
		switch ch {
		case '-':
			foundDash = true
		case '\n':
			cs := Cave(start)
			ce := Cave(end)
			if ce != START {
				neighbors[cs] = append(neighbors[cs], ce)
			}
			if cs != START {
				neighbors[ce] = append(neighbors[ce], cs)
			}
			start = 0
			end = 0
			foundDash = false
		default:
			if foundDash {
				end = end<<8 + int(ch)
			} else {
				start = start<<8 + int(ch)
			}
		}
	}
	return &CaveSystem{neighbors}
}

func (c *CaveSystem) Solve(start Cave, seen map[Cave]bool, p2 bool, twice bool) int {
	if start == END {
		return 1
	}
	if (start & 0x20) == 0x20 { // lower case
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
		nseen := make(map[Cave]bool, len(seen)+4)
		for k := range seen {
			nseen[k] = true
		}
		paths += c.Solve(nb, nseen, p2, ntwice)
	}
	return paths
}

func (c *CaveSystem) Part1() int {
	return c.Solve(START, make(map[Cave]bool), false, false)
}

func (c *CaveSystem) Part2() int {
	return c.Solve(START, make(map[Cave]bool), true, false)
}

func main() {
	g := NewCaveSystem(InputBytes(input))
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
