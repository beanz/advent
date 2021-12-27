package main

import (
	_ "embed"
	"fmt"
	"math"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Path map[FP2]int

func Calc(inp []byte) (int, int) {
	u := NewFP2(0, -1)
	d := NewFP2(0, 1)
	l := NewFP2(-1, 0)
	r := NewFP2(1, 0)
	path := make(Path, 262144)
	p := NewFP2(0, 0)
	steps := 0
	var i int
	for ; i < len(inp); i++ {
		var dir FP2
		switch inp[i] {
		case 'U':
			dir = u
		case 'D':
			dir = d
		case 'L':
			dir = l
		case 'R':
			dir = r
		}
		i++
		c := int(inp[i] - '0')
		for i++; '0' <= inp[i] && inp[i] <= '9'; i++ {
			c = c*10 + int(inp[i]-'0')
		}
		for j := 0; j < c; j++ {
			p = p.Add(dir)
			steps++
			path[p] = steps
		}
		if inp[i] == '\n' {
			break
		}
	}
	minDist := math.MaxInt64
	minSteps := math.MaxInt64
	origin := NewFP2(0, 0)
	p = NewFP2(0, 0)
	steps = 0
	for i++; i < len(inp); i++ {
		var dir FP2
		switch inp[i] {
		case 'U':
			dir = u
		case 'D':
			dir = d
		case 'L':
			dir = l
		case 'R':
			dir = r
		}
		i++
		c := int(inp[i] - '0')
		for i++; '0' <= inp[i] && inp[i] <= '9'; i++ {
			c = c*10 + int(inp[i]-'0')
		}
		for j := 0; j < c; j++ {
			p = p.Add(dir)
			steps++
			if s1, ok := path[p]; ok {
				if s1+steps < minSteps {
					minSteps = s1 + steps
				}
				d := p.ManhattanDistance(origin)
				if d < minDist {
					minDist = d
				}
			}
		}
		if inp[i] == '\n' {
			break
		}
	}
	return minDist, minSteps
}

func main() {
	dist, steps := Calc(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", dist)
		fmt.Printf("Part 2: %d\n", steps)
	}
}

var benchmark = false
