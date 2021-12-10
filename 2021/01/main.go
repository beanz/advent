package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Game struct {
	in []int
}

func NewGame(in []int) *Game {
	return &Game{in}
}

func (g *Game) Part1() int {
	res := 0
	for i := 1; i < len(g.in); i++ {
		if g.in[i-1] < g.in[i] {
			res++
		}
	}
	return res
}

func (g *Game) Part2() int {
	res := 0
	for i := 3; i < len(g.in); i++ {
		if g.in[i-3] < g.in[i] {
			res++
		}
	}
	return res
}

func Windows(in []int, n int) [][]int {
	res := make([][]int, 0, len(in)-n+1)
	for i := n - 1; i < len(in); i++ {
		res = append(res, in[i-n+1:i+1])
	}
	return res
}

func (g *Game) Fun(n int) int {
	res := 0
	for _, w := range Windows(g.in, n+1) {
		if w[0] < w[len(w)-1] {
			res++
		}
	}
	return res
}

func main() {
	nums := InputInts(input)
	g := NewGame(nums)
	p1 := g.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := g.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
	//fmt.Printf("Part 1: %d\n", g.Fun(1))
	//fmt.Printf("Part 2: %d\n", g.Fun(3))
}

var benchmark = false
