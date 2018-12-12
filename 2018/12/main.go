package main

import (
	"fmt"
	"log"
	"os"
	"strings"

	. "github.com/beanz/advent-of-code-go"
)

type Game struct {
	gen   int
	init  string
	rules map[string]bool
	debug bool
}

func NewGame(lines []string) *Game {
	gen := SimpleReadInts(lines[0])[0]
	state := lines[1][15:]
	rules := map[string]bool{}
	for _, line := range lines[2:] {
		words := strings.Split(line, " => ")
		if len(words) == 2 && words[1] == "#" {
			rules[words[0]] = true
		}
	}
	return &Game{gen, state, rules, false}
}

func potSum(state string, offset int) int {
	s := 0
	for i := 0; i < len(state); i++ {
		if state[i] == '#' {
			s += i - offset
		}
	}
	return s
}

func (g *Game) Solve() int {
	offset := 0
	diff := 0
	state := g.init
	sum := potSum(state, offset)
	t := 1
	//fmt.Printf("0 [%d]: %s %d\n", offset, state, sum)
	for t <= g.gen {
		state = "...." + state + "...."
		offset += 4
		newState := ".."
		for i := 2; i < len(state)-2; i++ {
			ss := state[i-2 : i+3]
			if g.rules[ss] {
				newState += "#"
			} else {
				newState += "."
			}
		}
		firstPotIndex := strings.IndexByte(newState, '#')
		newState = newState[firstPotIndex:]
		offset -= firstPotIndex
		lastPotIndex := strings.LastIndexByte(newState, '#')
		newState = newState[:lastPotIndex+1]

		state = newState
		newSum := potSum(state, offset)
		newDiff := newSum - sum
		if newDiff == diff {
			break
		}
		sum = newSum
		//fmt.Printf("%d [%d]: %s %d\n", t, offset, state, sum)
		diff = newDiff
		t++
	}
	t--
	if t != g.gen {
		return sum + diff*(g.gen-t)
	}
	return sum
}

func (g *Game) Part1() int {
	g.gen = 20
	return g.Solve()
}

func (g *Game) Part2() int {
	return g.Solve()
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	g := NewGame(ReadLines(os.Args[1]))
	fmt.Printf("Part1: %d\n", g.Part1())
	g = NewGame(ReadLines(os.Args[1]))
	fmt.Printf("Part2: %d\n", g.Part2())
}
