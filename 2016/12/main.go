package main

import (
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

func Part1(p *ElfProg2016) int {
	return p.Run()
}

func Part2(p *ElfProg2016) int {
	p.Reg["c"] = 1
	return p.Run()
}

func main() {
	elfProg := ReadElfProg2016(ReadInputLines())
	fmt.Printf("Part 1: %d\n", Part1(elfProg))
	elfProg = ReadElfProg2016(ReadInputLines())
	fmt.Printf("Part 2: %d\n", Part2(elfProg))
}
