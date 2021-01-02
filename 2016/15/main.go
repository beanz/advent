package main

import (
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

type Disc struct {
	num       int
	positions int
	start     int
}

func (d Disc) IsAligned(t int) bool {
	return ((t + d.num + d.start) % d.positions) == 0
}

type Game struct {
	discs []Disc
	debug bool
}

func readGame(lines []string) *Game {
	game := Game{[]Disc{}, false}
	for _, line := range lines {
		ints := Ints(line)
		game.discs = append(game.discs, Disc{ints[0], ints[1], ints[3]})
	}
	return &game
}

func (g *Game) Play() int {
	t := 0
	for {
		ok := true
		for _, d := range g.discs {
			ok = ok && d.IsAligned(t)
		}
		if ok {
			break
		}
		t++
	}
	return t
}

func (g *Game) Part1() int {
	return g.Play()
}

func (g *Game) Part2() int {
	g.discs = append(g.discs, Disc{7, 11, 0})
	return g.Play()
}

func main() {
	game := readGame(ReadInputLines())
	fmt.Printf("Part 1: %d\n", game.Part1())
	fmt.Printf("Part 2: %d\n", game.Part2())
}
