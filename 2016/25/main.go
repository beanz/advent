package main

import (
	_ "embed"
	"fmt"
	"log"
	"os"
	"regexp"
	"strconv"
	"strings"
	aoc "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Inst struct {
	kind string
	args []string
}

func (i *Inst) String() string {
	return fmt.Sprintf("%s %v", i.kind, i.args)
}

type Game struct {
	inst  []*Inst
	ip    int
	reg   map[string]int
	debug bool
}

func (g *Game) String() string {
	s := ""
	for _, r := range []string{"a", "b", "c", "d"} {
		s += fmt.Sprintf("%d ", g.reg[r])
	}
	s += fmt.Sprintf("%d: %s", g.ip, g.inst[g.ip])
	return s
}

func readGame(input string) *Game {
	lines := strings.Split(input, "\n")
	g := &Game{[]*Inst{}, 0, map[string]int{}, false}
	g.reg["a"] = 0
	g.reg["b"] = 0
	g.reg["c"] = 0
	g.reg["d"] = 0
	instRe := regexp.MustCompile(`^(inc|dec|jnz|cpy|out)\s+(.*)$`)
	for _, l := range lines[:len(lines)-1] {
		m := instRe.FindStringSubmatch(l)
		if m == nil {
			log.Fatalf("Invalid instruction: %s\n", l)
		}
		g.inst = append(g.inst, &Inst{m[1], strings.Split(m[2], " ")})
	}
	return g
}

func (g *Game) RegValueOrImmediate(s string) int {
	if s == "a" || s == "b" || s == "c" || s == "d" {
		return g.reg[s]
	}
	val, _ := strconv.Atoi(s)
	return val
}

func (g *Game) Run() bool {
	g.ip = 0
	out := 0
	outCount := 0
	for g.ip < len(g.inst) {
		if g.debug {
			fmt.Printf("%s\n", g)
		}
		in := g.inst[g.ip]
		switch in.kind {
		case "inc":
			g.reg[in.args[0]]++
			g.ip++
		case "dec":
			g.reg[in.args[0]]--
			g.ip++
		case "cpy":
			g.reg[in.args[1]] = g.RegValueOrImmediate(in.args[0])
			g.ip++
		case "jnz":
			val := g.RegValueOrImmediate(in.args[0])
			jmp := g.RegValueOrImmediate(in.args[1])
			if val == 0 {
				jmp = 1
			}
			g.ip += jmp
		case "out":
			val := g.RegValueOrImmediate(in.args[0])
			if val != out {
				if g.debug {
					fmt.Printf("out called but with %d not %d\n", val, out)
				}
				return false
			}
			if g.debug {
				fmt.Printf("out called with %d\n", val)
			}
			if outCount > 20 {
				return true
			}
			out = 1 - out
			outCount++
			g.ip++
		default:
			fmt.Fprintf(os.Stderr, "Unsupported instruction: %s\n", in)
			g.ip++
		}
	}
	return false
}
func (g *Game) Part1() int {
	for a := 0; ; a++ {
		if g.debug {
			fmt.Printf("Testing %d\n", a)
		}
		g.reg["a"] = a
		if g.Run() {
			return a
		}
	}
	return -1
}

func main() {
	game := readGame(aoc.InputString(input))
	p1 := game.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
}

var benchmark = false
