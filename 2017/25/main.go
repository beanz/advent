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
	state byte
}

type Rules map[byte]map[bool]Action

type Game struct {
	tape  map[int]bool
	cur   int
	state byte
	iter  int
	rules Rules
	debug bool
}

func (g *Game) String() string {
	s := string(g.state) + ": "
	var min, max int
	if len(g.tape) == 0 {
		min = -2
		max = 2
	} else {
		min = math.MaxInt64
		max = math.MinInt64
		for i := range g.tape {
			if i < min {
				min = i
			}
			if i > max {
				max = i
			}
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

func ReadAction(lines []string) Action {
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
	state := lines[2][len(lines[2])-2]
	return Action{value, dir, state}
}

func NewGame(chunks []string) *Game {
	g := &Game{map[int]bool{}, 0, 'A', 0, Rules{}, false}
	lines := strings.Split(chunks[0], "\n")
	if len(lines) != 2 {
		log.Fatalf("Expected setup chunk but found: %s\n", chunks[0])
	}
	if !strings.HasPrefix(lines[0], "Begin in state") {
		log.Fatalf("Expected initial state but found: %s\n", lines[0])
	}
	g.state = lines[0][len(lines[0])-2]
	if !strings.HasPrefix(lines[1], "Perform") {
		log.Fatalf("Expected number of iterations but found: %s\n", lines[1])
	}
	ints := SimpleReadInts(lines[1])
	g.iter = ints[0]
	for _, chunk := range chunks[1:] {
		lines := strings.Split(chunk, "\n")
		if !strings.HasPrefix(lines[0], "In state") {
			log.Fatalf("Expected state definition but found: %s\n", lines[0])
		}
		state := lines[0][len(lines[0])-2]
		g.rules[state] = map[bool]Action{}
		g.rules[state][false] = ReadAction(lines[2:5])
		g.rules[state][true] = ReadAction(lines[6:9])
	}
	return g
}

func (g *Game) Part1() int {
	for i := 1; i <= g.iter; i++ {
		value := g.tape[g.cur]
		action, ok := g.rules[g.state][value]
		if !ok {
			log.Fatalf("Unexpected state: state=%s value=%t\n",
				string(g.state), value)
		}
		if action.value {
			g.tape[g.cur] = true
		} else {
			delete(g.tape, g.cur)
		}
		g.cur += action.dir
		g.state = action.state
	}
	return len(g.tape)
}

func main() {
	chunks := InputChunks(input)
	p1 :=  NewGame(chunks).Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
}

var benchmark = false
