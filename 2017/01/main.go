package main

import (
	"fmt"
	"log"
	"os"

	. "github.com/beanz/advent/lib-go"
)

type Game struct {
	l string
}

func readGame(line string) *Game {
	return &Game{line}
}

func Sum1(s string) int {
	c := 0
	for i := 0; i < len(s); i++ {
		if s[i] == s[(i+1)%len(s)] {
			c += int(byte(s[i]) - 48)
		}
	}
	return c
}

func (g *Game) Part1() int {
	return Sum1(g.l)
}

func Sum2(s string) int {
	c := 0
	for i := 0; i < len(s); i++ {
		if s[i] == s[(i+len(s)/2)%len(s)] {
			c += int(byte(s[i]) - 48)
		}
	}
	return c
}

func (g *Game) Part2() int {
	return Sum2(g.l)
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	input := os.Args[1]
	game := readGame(ReadLines(input)[0])

	fmt.Printf("Part 1: %d\n", game.Part1())
	fmt.Printf("Part 2: %d\n", game.Part2())
}
