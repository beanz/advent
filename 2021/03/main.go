package main

import (
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

type Game struct {
	in []int
	bits int
}

func NewGame(in []string) *Game {
	g := &Game{make([]int, 0, len(in)), len(in[0])-1}
	for _, l := range in {
		g.in = append(g.in, BinToInt(l))
	}
	return g
}

func (g *Game) Part1() int {
	half := len(g.in)/2
	var gamma int
	for bit := (1<<g.bits); bit >= 1; bit /= 2 {
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
	return gamma*(2<<g.bits-1-gamma)
}

func (g *Game) Reduce(most bool) int {
	mask := 0
	val := 0
	for bit := (1<<g.bits); bit >= 1; bit /= 2 {
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
	lines := ReadInputLines()
	g := NewGame(lines)
	fmt.Printf("Part 1: %d\n", g.Part1())
	fmt.Printf("Part 2: %d\n", g.Part2())
}
