package main

import (
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Caves struct {
	nb    []int
	names map[int]string
	ids   map[string]int
	lower int
	max   int
}

const (
	NUM_CAVES         = 16 // 16 seems small but only 12 in my input
	TWO_POW_NUM_CAVES = 65536
	START             = 0
	END               = 1
)

func NewCaves(in []byte) *Caves {
	c := &Caves{
		nb:    make([]int, TWO_POW_NUM_CAVES),
		names: make(map[int]string, NUM_CAVES),
		ids:   make(map[string]int, NUM_CAVES),
		lower: 0,
		max:   1,
	}
	c.ids["start"], c.names[0] = 0, "start"
	c.ids["end"], c.names[1] = 1, "end"

	var start, dash int
	for i, ch := range in {
		switch ch {
		case '-':
			dash = i
		case '\n':
			c.AddPath(string(in[start:dash]), string(in[dash+1:i]))
			start = i + 1
		}
	}
	return c
}

func (c *Caves) CaveID(cave string) int {
	if v, ok := c.ids[cave]; ok {
		return v
	}
	c.max <<= 1
	c.ids[cave] = c.max
	c.names[c.max] = cave
	if cave[0] >= 'a' && cave[0] <= 'z' {
		c.lower |= c.max
	}
	return c.max
}

func (c *Caves) AddPath(s, e string) {
	start := c.CaveID(s)
	end := c.CaveID(e)
	if end != START { // don't bother adding paths to "start"
		c.nb[start] |= end
	}
	if start != START { // don't bother adding paths to "start"
		c.nb[end] |= start
	}
}

func (c *Caves) Solve(start int, seen int, p2 bool, twice bool) int {
	if start == END {
		return 1
	}
	if (c.lower & start) != 0 {
		seen |= start
	}
	paths := 0
	neighbors := c.nb[start]
	for nb := 1; nb <= c.max; nb <<= 1 {
		if (nb & neighbors) == 0 {
			continue
		}
		ntwice := twice
		if (seen & nb) != 0 {
			if !p2 || twice {
				continue
			}
			ntwice = true
		}
		paths += c.Solve(nb, seen, p2, ntwice)
	}
	return paths
}

func (c *Caves) Part1() int {
	return c.Solve(START, 0, false, false)
}

func (c *Caves) Part2() int {
	return c.Solve(START, 0, true, false)
}

func main() {
	c := NewCaves(InputBytes(input))
	p1 := c.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := c.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
