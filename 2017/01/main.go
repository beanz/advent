package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"strings"
)

type Game struct {
	l []string
}

func readInput(file string) *Game {
	b, err := ioutil.ReadFile(file)
	if err != nil {
		log.Fatalf("Failed to read input %s", err)
	}
	lines := strings.Split(string(b), "\n")
	return &Game{lines[:len(lines)-1]}
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

func (g *Game) Part1() string {
	s := ""
	for _, l := range g.l {
		s += fmt.Sprintf("%d ", Sum1(l))
	}
	return s
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

func (g *Game) Part2() string {
	s := ""
	for _, l := range g.l {
		s += fmt.Sprintf("%d ", Sum2(l))
	}
	return s
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	input := os.Args[1]
	game := readInput(input)

	res := game.Part1()
	fmt.Printf("Part 1: %s\n", res)

	res = game.Part2()
	fmt.Printf("Part 2: %s\n", res)
}
