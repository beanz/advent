package main

import (
	_ "embed"
	"fmt"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Game struct {
	gen   int64
	init  string
	rules map[string]bool
	debug bool
}

func NewGame(lines []string) *Game {
	var gen int64 = 50000000000
	if len(lines) < 20 {
		gen = 20
	}
	state := lines[0][15:]
	rules := map[string]bool{}
	for _, line := range lines[1:] {
		words := strings.Split(line, " => ")
		if len(words) == 2 && words[1] == "#" {
			rules[words[0]] = true
		}
	}
	return &Game{gen, state, rules, false}
}

func potSum(state string, offset int64) int64 {
	s := int64(0)
	for i := 0; i < len(state); i++ {
		if state[i] == '#' {
			s += int64(i) - offset
		}
	}
	return s
}

func (g *Game) Solve() int64 {
	offset := int64(0)
	diff := int64(0)
	state := g.init
	sum := potSum(state, offset)
	t := int64(1)
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
		offset -= int64(firstPotIndex)
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

func (g *Game) Part1() int64 {
	g.gen = 20
	return g.Solve()
}

func (g *Game) Part2() int64 {
	return g.Solve()
}

func main() {
	g := NewGame(InputLines(input))
	p1 := g.Part1()
	if !benchmark {
		fmt.Printf("Part1: %d\n", p1)
	}
	g = NewGame(InputLines(input))
	p2 := g.Part2()
	if !benchmark {
		fmt.Printf("Part2: %d\n", p2)
	}
}

var benchmark = false
