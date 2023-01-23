package aoc

import (
	"fmt"
	"strings"
)

type Inst struct {
	Op string
	A  int
	B  int
	C  int
}

func (i *Inst) String() string {
	return fmt.Sprintf("%s %d %d %d", i.Op, i.A, i.B, i.C)
}

type ElfProg2018 struct {
	Prog  []*Inst
	IP    int
	Reg   [6]int
	bound int
	debug bool
}

func (g *ElfProg2018) String() string {
	return fmt.Sprintf("ip=%d %v %s", g.IP, g.Reg, g.Prog[0])
}

func NewElfProg2018(lines []string) *ElfProg2018 {
	g := &ElfProg2018{[]*Inst{}, 0,
		[6]int{}, SimpleReadInts(lines[0])[0], false}
	for _, l := range lines[1:] {
		args := SimpleReadInts(l)
		g.Prog = append(g.Prog,
			&Inst{strings.Split(l, " ")[0], args[0], args[1], args[2]})
	}
	return g
}

func (g *ElfProg2018) Run(fn func(*ElfProg2018) bool) int {
	for g.IP < len(g.Prog) {
		inst := g.Prog[g.IP]
		g.Reg[g.bound] = g.IP
		switch inst.Op {
		case "addr":
			g.Reg[inst.C] = g.Reg[inst.A] + g.Reg[inst.B]
		case "addi":
			g.Reg[inst.C] = g.Reg[inst.A] + inst.B
		case "mulr":
			g.Reg[inst.C] = g.Reg[inst.A] * g.Reg[inst.B]
		case "muli":
			g.Reg[inst.C] = g.Reg[inst.A] * inst.B
		case "banr":
			g.Reg[inst.C] = g.Reg[inst.A] & g.Reg[inst.B]
		case "bani":
			g.Reg[inst.C] = g.Reg[inst.A] & inst.B
		case "borr":
			g.Reg[inst.C] = g.Reg[inst.A] | g.Reg[inst.B]
		case "bori":
			g.Reg[inst.C] = g.Reg[inst.A] | inst.B
		case "setr":
			g.Reg[inst.C] = g.Reg[inst.A]
		case "seti":
			g.Reg[inst.C] = inst.A
		case "gtir":
			if inst.A > g.Reg[inst.B] {
				g.Reg[inst.C] = 1
			} else {
				g.Reg[inst.C] = 0
			}
		case "gtri":
			if g.Reg[inst.A] > inst.B {
				g.Reg[inst.C] = 1
			} else {
				g.Reg[inst.C] = 0
			}
		case "gtrr":
			if g.Reg[inst.A] > g.Reg[inst.B] {
				g.Reg[inst.C] = 1
			} else {
				g.Reg[inst.C] = 0
			}
		case "eqir":
			if inst.A == g.Reg[inst.B] {
				g.Reg[inst.C] = 1
			} else {
				g.Reg[inst.C] = 0
			}
		case "eqri":
			if g.Reg[inst.A] == inst.B {
				g.Reg[inst.C] = 1
			} else {
				g.Reg[inst.C] = 0
			}
		case "eqrr":
			if g.Reg[inst.A] == g.Reg[inst.B] {
				g.Reg[inst.C] = 1
			} else {
				g.Reg[inst.C] = 0
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
