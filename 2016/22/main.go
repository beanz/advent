package main

import (
	_ "embed"
	"fmt"
	"regexp"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Node struct {
	used int
	free int
}

type Game struct {
	nodes map[Point]*Node
	w, h  int
	debug bool
}

func readGame(lines []string) *Game {
	g := &Game{map[Point]*Node{}, 0, 0, false}
	re := regexp.MustCompile(`-x(\d+)-y(\d+)\s+(\d+)T\s+(\d+)T\s+(\d+)T`)
	for _, l := range lines {
		m := re.FindStringSubmatch(l)
		if m == nil {
			continue
		}
		x := MustParseInt(m[1])
		y := MustParseInt(m[2])
		u := MustParseInt(m[4])
		f := MustParseInt(m[5])
		g.nodes[Point{x, y}] = &Node{u, f}
		if x >= g.w {
			g.w = x + 1
		}
		if y >= g.h {
			g.h = y + 1
		}
	}
	return g
}

func (g Game) Part1() int {
	count := 0
	max := g.w * g.h
	for i := 0; i < max; i++ {
		for j := i + 1; j < max; j++ {
			n1 := g.nodes[Point{i % g.w, i / g.w}]
			n2 := g.nodes[Point{j % g.w, j / g.w}]
			if (n1.used != 0 && n1.used <= n2.free) ||
				(n2.used != 0 && n2.used <= n1.free) {
				count++
			}
		}
	}
	return count
}

func (g Game) Part2() int {
	empty := Point{-1, -1}
	full := 0
	for y := 0; y < g.h; y++ {
		for x := 0; x < g.w; x++ {
			if x == 0 && y == 0 {
				//fmt.Print("G")
				continue
			}
			if x == g.w-1 && y == 0 {
				//fmt.Print("T")
				continue
			}
			p := Point{x, y}
			used := g.nodes[p].used
			if used == 0 {
				empty = p
				//fmt.Print("_")
				continue
			}
			if used > 150 {
				full++
				//fmt.Print("#")
				continue
			}
			//fmt.Print(".")
		}
		//fmt.Println()
		if empty.X != -1 {
			break
		}
	}
	//fmt.Printf("Empty point: %s\n", empty)
	//fmt.Printf("Width: %d\n", g.w)
	// steps to go around the full spaces
	n := 1 + full - (g.w - empty.X) + full
	// plus height plus steps to move across
	return n + empty.Y + (g.w-2)*5
}

func main() {
	game := readGame(InputLines(input))
	p1 := game.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := game.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
