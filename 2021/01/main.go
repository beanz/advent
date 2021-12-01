package main

import (
	"fmt"
	"log"
	"os"

	. "github.com/beanz/advent/lib-go"
)

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
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}

	nums := ReadIntsFromFile(os.Args[1])
	g := NewGame(nums)
	fmt.Printf("Part 1: %d\n", g.Part1())
	fmt.Printf("Part 1: %d\n", g.Fun(1))
	fmt.Printf("Part 2: %d\n", g.Part2())
	fmt.Printf("Part 2: %d\n", g.Fun(3))
}
