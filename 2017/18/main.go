package main

import (
	"fmt"
	"log"
	"os"
	"sort"
	"strconv"
	"strings"
	"time"

	aoc "github.com/beanz/advent/lib-go"
)

type Reg map[byte]int

type Inst func(*Game)

type Game struct {
	prog      []Inst
	regs      Reg
	ip        int
	snd       int
	rcv       int
	sendCount int
	id        int
	debug     bool
}

func (g *Game) String() string {
	s := fmt.Sprintf("%d %d: ", g.id, g.ip)
	r := []int{}
	for k := range g.regs {
		r = append(r, int(k))
	}
	sort.Ints(r)

	for _, b := range r {
		if g.regs[byte(b)] != 0 {
			s += fmt.Sprintf("%s=%d ", string(byte(b)), g.regs[byte(b)])
		}
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

func NewGame(lines []string, cs, cr chan int, id int) *Game {
	g := &Game{[]Inst{}, Reg{}, 0, 0, 0, 0, id, false}
	g.regs['p'] = id
	for _, line := range lines {
		inst := strings.Split(line, " ")
		reg := inst[1][0]
		var fn Inst
		switch inst[0] {
		case "snd":
			fn = func(*Game) {
				if cs != nil {
					select {
					case cs <- g.regs[reg]:
						g.sendCount++
						if g.debug {
							fmt.Printf("send %d from %d\n",
								g.regs[reg], g.id)
						}
					case <-time.After(1 * time.Second):
						g.ip += 1000000
					}
				} else {
					g.snd = g.regs[reg]
				}
				g.ip++
			}
		case "rcv":
			fn = func(*Game) {
				if cr != nil {
					select {
					case g.regs[reg] = <-cr:
						if g.debug {
							fmt.Printf("got %d from %d\n", g.regs[reg], g.id)
						}
					case <-time.After(1 * time.Second):
						g.ip += 1000000
					}
				} else {
					if g.regs[reg] != 0 {
						g.rcv = g.snd
					}
				}
				g.ip++
			}
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
		case "mul":
			fn = func(*Game) {
				val := g.regValueOrImmediate(inst[2])
				g.regs[reg] *= val
				g.ip++
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
		if g.rcv != 0 {
			return g.rcv
		}
	}
	return -1
}

func Part2(lines []string) int {
	to0 := make(chan int, 10000)
	to1 := make(chan int, 10000)
	g0 := NewGame(lines, to1, to0, 0)
	g1 := NewGame(lines, to0, to1, 1)
	go g1.Part1()
	g0.Part1()
	return g1.sendCount
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := aoc.ReadLines(os.Args[1])
	fmt.Printf("Part 1: %d\n", NewGame(lines, nil, nil, 0).Part1())
	fmt.Printf("Part 2: %d\n", Part2(lines))
}
