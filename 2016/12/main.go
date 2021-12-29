package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
	"github.com/beanz/advent/lib-go/elfprog2016"
)

//go:embed input.txt
var input []byte

func Part1(p *elfprog2016.ElfProg) int {
	return p.Run()
}

func Part2(p *elfprog2016.ElfProg) int {
	p.SetReg(2, 1)
	return p.Run()
}

func main() {
	elfProg := elfprog2016.NewElfProg(InputBytes(input))
	p1 := Part1(elfProg)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := Part2(elfProg)
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
