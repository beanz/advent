package main

import (
	"fmt"
	"log"
	"os"
	"regexp"
	"strconv"

	. "github.com/beanz/advent-of-code-go"
)

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
		x, _ := strconv.Atoi(m[1])
		y, _ := strconv.Atoi(m[2])
		u, _ := strconv.Atoi(m[4])
		f, _ := strconv.Atoi(m[5])
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
	for y := 0; y < g.h; y++ {
		for x := 0; x < g.w; x++ {
			if x == 0 && y == 0 {
				fmt.Print("G")
				continue
			}
			if x == g.w-1 && y == 0 {
				fmt.Print("T")
				continue
			}
			p := Point{x, y}
			used := g.nodes[p].used
			if used == 0 {
				empty = p
				fmt.Print("_")
				continue
			}
			if used > 150 {
				fmt.Print("#")
				continue
			}
			fmt.Print(".")
		}
		fmt.Println()
		if empty.X != -1 {
			break
		}
	}
	fmt.Printf("Empty point: %s\n", empty)
	fmt.Printf("Width: %d\n", g.w)
	return empty.X + empty.Y + (g.w - 1) + (g.w-2)*5
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	input := os.Args[1]
	game := readGame(ReadLines(input))
	fmt.Printf("Part 1: %d\n", game.Part1())
	fmt.Printf("Part 2: %d\n", game.Part2())
}