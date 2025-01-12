package main

import (
	_ "embed"
	"fmt"
	"log"
	"strconv"
	"strings"

	aoc "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Reg map[byte]int

type Inst func(*Game)

type Game struct {
	prog  []Inst
	regs  Reg
	ip    int
	count int
	debug bool
}

func (g *Game) String() string {
	s := fmt.Sprintf("%d: ", g.ip)
	for _, k := range []byte{'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'} {
		s += fmt.Sprintf("%s=%d ", string(k), g.regs[k])
	}
	return s
}

func (g *Game) regValueOrImmediate(s string) int {
	if 'a' <= s[0] && s[0] <= 'z' {
		return g.regs[s[0]]
	}
	val, _ := strconv.Atoi(s)
	return val
}

func NewGame(lines []string) *Game {
	g := &Game{[]Inst{}, Reg{}, 0, 0, false}
	for _, line := range lines {
		inst := strings.Split(line, " ")
		reg := inst[1][0]
		var fn Inst
		switch inst[0] {
		case "set":
			fn = func(*Game) {
				val := g.regValueOrImmediate(inst[2])
				g.regs[reg] = val
				g.ip++
			}
		case "add":
			fn = func(*Game) {
				val := g.regValueOrImmediate(inst[2])
				g.regs[reg] += val
				g.ip++
			}
		case "sub":
			fn = func(*Game) {
				val := g.regValueOrImmediate(inst[2])
				g.regs[reg] -= val
				g.ip++
			}
		case "mul":
			fn = func(*Game) {
				val := g.regValueOrImmediate(inst[2])
				g.regs[reg] *= val
				g.ip++
				g.count++
			}
		case "mod":
			fn = func(*Game) {
				val := g.regValueOrImmediate(inst[2])
				g.regs[reg] %= val
				g.ip++
			}
		case "jgz":
			fn = func(*Game) {
				val := g.regValueOrImmediate(inst[2])
				test := g.regValueOrImmediate(inst[1])
				if test > 0 {
					g.ip += val
				} else {
					g.ip++
				}
			}
		case "jnz":
			fn = func(*Game) {
				val := g.regValueOrImmediate(inst[2])
				test := g.regValueOrImmediate(inst[1])
				if test != 0 {
					g.ip += val
				} else {
					g.ip++
				}
			}
		default:
			log.Fatalf("Invalid instruction in line %s\n", line)
		}
		g.prog = append(g.prog, fn)
	}
	return g
}

func (g *Game) Part1() int {
	for g.ip < len(g.prog) {
		if g.debug {
			fmt.Printf("%s\n", g)
		}
		g.prog[g.ip](g)
	}
	return g.count
}

func (g *Game) Part2() int {
	g.prog[0](g)
	n := g.regs['b']
	p2 := 0
	b := n*100 + 100000
	c := b + 17000
	for ; b <= c; b += 17 {
		if b&1 == 0 {
			p2++
			continue
		}
		for d := 3; d*d < b; d += 2 {
			if b%d == 0 {
				p2++
				break
			}
		}
	}
	return p2
}

func main() {
	lines := aoc.InputLines(input)
	p1 := NewGame(lines).Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := NewGame(lines).Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
