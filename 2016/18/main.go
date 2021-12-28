package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Game struct {
	row      []byte
	p1c, p2c int
	count    int
}

func NewGame(in []byte) *Game {
	return &Game{in[:len(in)-1], 40, 400000, 0}
}

func (g *Game) NewTile(p []bool, x int) bool {
	var left, right bool
	if x > 0 {
		left = p[x-1]
	}
	if x < len(p)-1 {
		right = p[x+1]
	}
	if left != right {
		return true
	}
	g.count++
	return false
}

func (g *Game) Parts() (int, int) {
	l := len(g.row)
	p := make([]bool, l)
	for x := 0; x < len(g.row); x++ {
		p[x] = g.row[x] == '^'
		if !p[x] {
			g.count++
		}
	}
	n := make([]bool, 0, l)
	y := 1
	for ; y < g.p1c; y++ {
		for x := 0; x < l; x++ {
			n = append(n, g.NewTile(p, x))
		}
		p, n = n, p[:0]
	}
	p1 := g.count
	for ; y < g.p2c; y++ {
		for x := 0; x < l; x++ {
			n = append(n, g.NewTile(p, x))
		}
		p, n = n, p[:0]
	}
	return p1, g.count
}

func main() {
	game := NewGame(InputBytes(input))
	p1, p2 := game.Parts()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
