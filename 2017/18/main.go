package main

import (
	_ "embed"
	"fmt"
	"log"
	"strconv"
	"strings"
	"time"

	aoc "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Reg []int

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
	for i, v := range g.regs {
		if v != 0 {
			s += fmt.Sprintf("%s=%d ", string('a'+byte(i)), v)
		}
	}
	return s
}

func (g *Game) regOrImmediate(s string) (int, bool) {
	if 'a' <= s[0] && s[0] <= 'z' {
		return int(byte(s[0]) - 'a'), true
	}
	val, _ := strconv.Atoi(s)
	return val, false
}

func NewGame(lines []string, cs, cr chan int, id int) *Game {
	regs := make(Reg, 26)
	g := &Game{[]Inst{}, regs, 0, 0, 0, 0, id, false}
	g.regs['p'-'a'] = id
	for _, line := range lines {
		inst := strings.Split(line, " ")
		reg := int(byte(inst[1][0]) - 'a')
		var fn Inst
		switch inst[0] {
		case "snd":
			fn = func(*Game) {
				if cs != nil {
					delay := time.NewTimer(400 * time.Microsecond)
					select {
					case cs <- g.regs[reg]:
						if !delay.Stop() {
							<-delay.C
						}
						g.sendCount++
						if g.debug {
							fmt.Printf("send %d from %d\n",
								g.regs[reg], g.id)
						}
					case <-delay.C:
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
					delay := time.NewTimer(400 * time.Microsecond)
					select {
					case g.regs[reg] = <-cr:
						if !delay.Stop() {
							<-delay.C
						}
						if g.debug {
							fmt.Printf("got %d from %d\n", g.regs[reg], g.id)
						}
					case <-delay.C:
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
			v, isReg := g.regOrImmediate(inst[2])
			if isReg {
				fn = func(*Game) {
					g.regs[reg] = g.regs[v]
					g.ip++
				}
			} else {
				fn = func(*Game) {
					g.regs[reg] = v
					g.ip++
				}
			}
		case "add":
			v, isReg := g.regOrImmediate(inst[2])
			if isReg {
				fn = func(*Game) {
					g.regs[reg] += g.regs[v]
					g.ip++
				}
			} else {
				fn = func(*Game) {
					g.regs[reg] += v
					g.ip++
				}
			}
		case "mul":
			v, isReg := g.regOrImmediate(inst[2])
			if isReg {
				fn = func(*Game) {
					g.regs[reg] *= g.regs[v]
					g.ip++
				}
			} else {
				fn = func(*Game) {
					g.regs[reg] *= v
					g.ip++
				}
			}
		case "mod":
			v, isReg := g.regOrImmediate(inst[2])
			if isReg {
				fn = func(*Game) {
					g.regs[reg] %= g.regs[v]
					g.ip++
				}
			} else {
				fn = func(*Game) {
					g.regs[reg] %= v
					g.ip++
				}
			}
		case "jgz":
			v1, isReg1 := g.regOrImmediate(inst[1])
			v2, isReg2 := g.regOrImmediate(inst[2])
			if isReg1 {
				if isReg2 {
					fn = func(*Game) {
						if g.regs[v1] > 0 {
							g.ip += g.regs[v2]
						} else {
							g.ip++
						}
					}
				} else {
					fn = func(*Game) {
						if g.regs[v1] > 0 {
							g.ip += v2
						} else {
							g.ip++
						}
					}
				}
			} else {
				if isReg2 {
					fn = func(*Game) {
						if v1 > 0 {
							g.ip += g.regs[v2]
						} else {
							g.ip++
						}
					}
				} else {
					fn = func(*Game) {
						if v1 > 0 {
							g.ip += v2
						} else {
							g.ip++
						}
					}
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
		//fmt.Printf("%s\n", g)
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
	lines := aoc.InputLines(input)
	p1 := NewGame(lines, nil, nil, 0).Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := Part2(lines)
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
