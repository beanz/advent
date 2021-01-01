package main

import (
	"fmt"
	"strings"

	. "github.com/beanz/advent2015/lib"
)

const (
	RA = 0
	RB = 1
)

type Inst struct {
	op     string
	reg    int
	offset int
	s      string
}

type Comp struct {
	reg  [2]uint
	ip   int
	inst []Inst
}

func NewComp(in []string) *Comp {
	inst := []Inst{}
	for _, l := range in {
		ss := strings.SplitN(l, " ", 2)
		reg := -1
		if ss[1][0] == 'b' {
			reg = RB
		} else if ss[1][0] == 'a' {
			reg = RA
		}
		ints := Ints(ss[1])
		offset := 0
		if len(ints) > 0 {
			offset = ints[0]
		}
		inst = append(inst, Inst{op: ss[0], reg: reg, offset: offset, s: l})
	}
	return &Comp{inst: inst}
}

func (c *Comp) Run() {
	for c.ip < len(c.inst) {
		inst := c.inst[c.ip]
		// fmt.Printf("CPU IP=%d RA=%d RB=%d: %s\n",
		// 	c.ip, c.reg[RA], c.reg[RB], inst.s)
		switch inst.op {
		case "hlf":
			c.reg[inst.reg] /= 2
			c.ip++
		case "tpl":
			c.reg[inst.reg] *= 3
			c.ip++
		case "inc":
			c.reg[inst.reg]++
			c.ip++
		case "jmp":
			c.ip += inst.offset
		case "jie":
			if (c.reg[inst.reg] % 2) == 0 {
				c.ip += inst.offset
			} else {
				c.ip++
			}
		case "jio":
			if c.reg[inst.reg] == 1 {
				c.ip += inst.offset
			} else {
				c.ip++
			}
		default:
			panic("Invalid instruction: " + inst.op)
		}
	}
}

func (c *Comp) Part1() uint {
	c.Run()
	return c.reg[RB]
}

func (c *Comp) Part2() uint {
	c.ip = 0
	c.reg[RA], c.reg[RB] = 1, 0
	c.Run()
	return c.reg[RB]
}

func main() {
	g := NewComp(ReadInputLines())
	fmt.Printf("Part 1: %d\n", g.Part1())
	fmt.Printf("Part 2: %d\n", g.Part2())
}
