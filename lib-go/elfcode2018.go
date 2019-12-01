package aoc

import (
	"fmt"
	"strings"
)

type Inst struct {
	op string
	a  int
	b  int
	c  int
}

func (i *Inst) String() string {
	return fmt.Sprintf("%s %d %d %d", i.op, i.a, i.b, i.c)
}

type ElfProg2018 struct {
	prog  []*Inst
	IP    int
	Reg   [6]int
	bound int
	debug bool
}

func (g *ElfProg2018) String() string {
	return fmt.Sprintf("ip=%d %v %s", g.IP, g.Reg, g.prog[0])
}

func NewElfProg2018(lines []string) *ElfProg2018 {
	g := &ElfProg2018{[]*Inst{}, 0,
		[6]int{}, SimpleReadInts(lines[0])[0], false}
	for _, l := range lines[1:] {
		args := SimpleReadInts(l)
		g.prog = append(g.prog,
			&Inst{strings.Split(l, " ")[0], args[0], args[1], args[2]})
	}
	return g
}

func (g *ElfProg2018) Run(fn func(*ElfProg2018) bool) int {
	for g.IP < len(g.prog) {
		inst := g.prog[g.IP]
		g.Reg[g.bound] = g.IP
		switch inst.op {
		case "addr":
			g.Reg[inst.c] = g.Reg[inst.a] + g.Reg[inst.b]
		case "addi":
			g.Reg[inst.c] = g.Reg[inst.a] + inst.b
		case "mulr":
			g.Reg[inst.c] = g.Reg[inst.a] * g.Reg[inst.b]
		case "muli":
			g.Reg[inst.c] = g.Reg[inst.a] * inst.b
		case "banr":
			g.Reg[inst.c] = g.Reg[inst.a] & g.Reg[inst.b]
		case "bani":
			g.Reg[inst.c] = g.Reg[inst.a] & inst.b
		case "borr":
			g.Reg[inst.c] = g.Reg[inst.a] | g.Reg[inst.b]
		case "bori":
			g.Reg[inst.c] = g.Reg[inst.a] | inst.b
		case "setr":
			g.Reg[inst.c] = g.Reg[inst.a]
		case "seti":
			g.Reg[inst.c] = inst.a
		case "gtir":
			if inst.a > g.Reg[inst.b] {
				g.Reg[inst.c] = 1
			} else {
				g.Reg[inst.c] = 0
			}
		case "gtri":
			if g.Reg[inst.a] > inst.b {
				g.Reg[inst.c] = 1
			} else {
				g.Reg[inst.c] = 0
			}
		case "gtrr":
			if g.Reg[inst.a] > g.Reg[inst.b] {
				g.Reg[inst.c] = 1
			} else {
				g.Reg[inst.c] = 0
			}
		case "eqir":
			if inst.a == g.Reg[inst.b] {
				g.Reg[inst.c] = 1
			} else {
				g.Reg[inst.c] = 0
			}
		case "eqri":
			if g.Reg[inst.a] == inst.b {
				g.Reg[inst.c] = 1
			} else {
				g.Reg[inst.c] = 0
			}
		case "eqrr":
			if g.Reg[inst.a] == g.Reg[inst.b] {
				g.Reg[inst.c] = 1
			} else {
				g.Reg[inst.c] = 0
			}
		}
		g.IP = g.Reg[g.bound]
		if fn(g) {
			break
		}
		g.IP++
	}
	return g.Reg[0]
}
