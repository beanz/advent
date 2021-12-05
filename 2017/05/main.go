package main

import (
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

type Prog struct {
	jumps []int
	ip    int
	debug bool
}

func NewProg(file string) *Prog {
	return &Prog{ReadInts(ReadLines(file)), 0, false}
}

func (p *Prog) Part1() int {
	p.ip = 0
	steps := 0
	for p.ip < len(p.jumps) {
		jump := p.jumps[p.ip]
		p.jumps[p.ip]++
		p.ip += jump
		steps++
	}
	return steps
}

func (p *Prog) Part2() int {
	p.ip = 0
	steps := 0
	for p.ip < len(p.jumps) {
		jump := p.jumps[p.ip]
		if jump >= 3 {
			p.jumps[p.ip]--
		} else {
			p.jumps[p.ip]++
		}
		p.ip += jump
		steps++
	}
	return steps
}

func main() {
	prog := NewProg(InputFile())
	fmt.Printf("Part 1: %d\n", prog.Part1())
	prog = NewProg(InputFile())
	fmt.Printf("Part 2: %d\n", prog.Part2())
}
