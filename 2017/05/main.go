package main

import (
	"fmt"
	"log"
	"os"

	. "github.com/beanz/advent-of-code-go"
)

type Prog struct {
	jumps []int
	ip    int
	debug bool
}

func NewProg(file string) *Prog {
	nums, err := ReadInts(ReadLines(file))
	if err != nil {
		log.Fatalf("Failed to read ints from file: %s\n", err)
	}
	return &Prog{nums, 0, false}
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
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	prog := NewProg(os.Args[1])
	fmt.Printf("Part 1: %d\n", prog.Part1())
	prog = NewProg(os.Args[1])
	fmt.Printf("Part 2: %d\n", prog.Part2())
}
