package main

import (
	"fmt"
	"log"
	"os"
	"regexp"
	"strconv"

	. "github.com/beanz/advent-of-code-go"
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
	lineRe := regexp.MustCompile(`Disc #(\d+) has (\d+) positions; at time=0, it is at position (\d+).`)
	for _, line := range lines {
		m := lineRe.FindStringSubmatch(line)
		if m == nil {
			log.Fatalf("invalid line:\n%s\n", line)
		}
		num, err := strconv.Atoi(m[1])
		if err != nil {
			log.Fatalf("invalid disc in line:\n%s\n", line)
		}
		positions, err := strconv.Atoi(m[2])
		if err != nil {
			log.Fatalf("invalid number of positions in line:\n%s\n", line)
		}
		start, err := strconv.Atoi(m[3])
		if err != nil {
			log.Fatalf("invalid start position in line:\n%s\n", line)
		}
		game.discs = append(game.discs, Disc{num, positions, start})
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
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	input := os.Args[1]
	game := readGame(ReadLines(input))
	//fmt.Printf("%s\n", game)
	fmt.Printf("Part 1: %d\n", game.Part1())
	//fmt.Printf("%s\n", game)

	fmt.Printf("Part 2: %d\n", game.Part2())
	//fmt.Printf("%s\n", game)
}
