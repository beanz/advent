package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Prog struct {
	jumps []int
	ip    int
	debug bool
}

func NewProg(inp []int) *Prog {
    return &Prog{inp, 0, false}
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
	prog := NewProg(InputInts(input))
	p1 := prog.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	prog = NewProg(InputInts(input))
	p2 := prog.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
