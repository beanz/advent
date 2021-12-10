package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Game struct {
	row   string
	h     int
	count int
	debug bool
}

func readGame(input string) *Game {
	return &Game{input, 40, 0, false}
}

func (g *Game) NewTile(p string, x int) string {
	var left, right byte
	if x > 0 {
		left = p[x-1]
	} else {
		left = '.'
	}
	if x < len(p)-1 {
		right = p[x+1]
	} else {
		right = '.'
	}
	if left == '^' && right == '.' {
		return "^"
	}
	if left == '.' && right == '^' {
		return "^"
	}
	g.count++
	return "."
}

func (g *Game) NewRow(c string) string {
	n := ""
	for x := 0; x < len(c); x++ {
		n += g.NewTile(c, x)
	}
	return n
}

func (g *Game) Part1() int {
	for x := 0; x < len(g.row); x++ {
		if g.row[x] == '.' {
			g.count++
		}
	}
	p := g.row
	if g.debug {
		fmt.Println(p)
	}
	for y := 1; y < g.h; y++ {
		p = g.NewRow(p)
		if g.debug {
			fmt.Println(p)
		}
	}
	return g.count
}

func (g *Game) Part2() int {
	g.h = 400000
	g.count = 0
	//g.debug = true
	return g.Part1()
}

func main() {
	game := readGame(InputLines(input)[0])
	res := game.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", res)
	}
	res = game.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", res)
	}
}

var benchmark = false
