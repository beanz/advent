package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Game struct {
	in   []int
	bits int
}

func NewGame(in []byte) *Game {
	bits := 0
	for ; in[bits] != '\n'; bits++ {
	}
	ints := make([]int, 0, 1000)
	n := 0
	for i := 0; i < len(in); i++ {
		if in[i] == '\n' {
			ints = append(ints, n)
			n = 0
			continue
		}
		n = (n << 1) + int(in[i]-'0')
	}
	return &Game{ints, bits - 1}
}

func (g *Game) Part1() int {
	half := len(g.in) / 2
	var gamma int
	for bit := (1 << g.bits); bit >= 1; bit /= 2 {
		c := 0
		for _, n := range g.in {
			if n&bit != 0 {
				c++
			}
		}
		if c > half {
			gamma += bit
		}
	}
	return gamma * (2<<g.bits - 1 - gamma)
}

func (g *Game) Reduce(most bool) int {
	mask := 0
	val := 0
	for bit := (1 << g.bits); bit >= 1; bit /= 2 {
		c := 0
		total := 0
		for _, n := range g.in {
			if n&mask != val {
				continue
			}
			total++
			if n&bit != 0 {
				c++
			}
		}
		if total == 1 {
			return g.Match(val, mask)
		}
		if c >= (total+1)/2 == most {
			val += bit
		}
		mask += bit
	}
	return val
}

func (g *Game) Match(val, mask int) int {
	for _, n := range g.in {
		if n&mask == val {
			return n
		}
	}
	return -1
}

func (g *Game) Part2() int {
	return g.Reduce(true) * g.Reduce(false)
}

func main() {
	g := NewGame(InputBytes(input))
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
