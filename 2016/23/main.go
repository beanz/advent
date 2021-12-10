package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Part1(p *ElfProg2016) int {
	p.Reg["a"] = 7
	return p.Run()
}

func Part2(p *ElfProg2016) int {
	p.Reg["a"] = 12
	return p.Run()
}

func main() {
	elfProg := ReadElfProg2016(InputLines(input))
	p1 := Part1(elfProg)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	elfProg = ReadElfProg2016(InputLines(input))
	p2 := Part2(elfProg)
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
