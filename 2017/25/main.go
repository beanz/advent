package main

import (
	_ "embed"
	"fmt"
	"log"
	"math"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Action struct {
	value bool
	dir   int
	state int
}

type Rules []*Action

type Game struct {
	tape  []bool
	cur   int
	state int
	iter  int
	rules Rules
	debug bool
}

func (g *Game) String() string {
	s := string(byte(g.state/2+'A')) + ": "
	var min, max int
	min = math.MaxInt64
	max = math.MinInt64
	for i, v := range g.tape {
		if !v {
			continue
		}
		if i < min {
			min = i
		}
		if i > max {
			max = i
		}
	}
	for i := min; i <= max; i++ {
		var ch string
		if g.tape[i] {
			ch = "1"
		} else {
			ch = "0"
		}
		if g.cur == i {
			s += "[" + ch + "]"
		} else {
			s += " " + ch + " "
		}
	}
	return s
}

func ReadAction(lines []string) *Action {
	var value bool
	switch lines[0][len(lines[0])-2] {
	case '1':
		value = true
	case '0':
		value = false
	default:
		log.Fatalf("Invalid value to write in: %s\n", lines[0])
	}

	var dir int
	switch {
	case strings.Contains(lines[1], "right"):
		dir = 1
	case strings.Contains(lines[1], "left"):
		dir = -1
	default:
		log.Fatalf("Invalid direction: %s\n", lines[1])
	}

	if !strings.Contains(lines[2], "Continue with state") {
		log.Fatalf("Expected next state line but found: %s\n", lines[2])
	}
	state := 2 * int(lines[2][len(lines[2])-2]-'A')
	return &Action{value, dir, state}
}

func NewGame(chunks []string) *Game {
	g := &Game{make([]bool, 10000), 1000, 'A', 0, Rules{}, false}
	lines := strings.Split(chunks[0], "\n")
	if len(lines) != 2 {
		log.Fatalf("Expected setup chunk but found: %s\n", chunks[0])
	}
	if !strings.HasPrefix(lines[0], "Begin in state") {
		log.Fatalf("Expected initial state but found: %s\n", lines[0])
	}
	g.state = 2 * int(lines[0][len(lines[0])-2]-'A')
	if !strings.HasPrefix(lines[1], "Perform") {
		log.Fatalf("Expected number of iterations but found: %s\n", lines[1])
	}
	ints := SimpleReadInts(lines[1])
	g.iter = ints[0]
	g.rules = make([]*Action, len(chunks)*2)
	for _, chunk := range chunks[1:] {
		lines := strings.Split(chunk, "\n")
		if !strings.HasPrefix(lines[0], "In state") {
			log.Fatalf("Expected state definition but found: %s\n", lines[0])
		}
		i := 2 * (lines[0][len(lines[0])-2] - 'A')
		g.rules[i] = ReadAction(lines[2:5])
		g.rules[i+1] = ReadAction(lines[6:9])
	}
	return g
}

func (g *Game) Part1() int {
	for i := 1; i <= g.iter; i++ {
		value := g.tape[g.cur]
		i := g.state
		if value {
			i++
		}
		action := g.rules[i]
		g.tape[g.cur] = action.value
		g.cur += action.dir
		g.state = action.state
	}
	c := 0
	for _, v := range g.tape {
		if v {
			c++
		}
	}
	return c
}

func main() {
	chunks := InputChunks(input)
	p1 := NewGame(chunks).Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
}

var benchmark = false
