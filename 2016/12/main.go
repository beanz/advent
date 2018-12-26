package main

import (
	"fmt"
	"log"
	"os"

	. "github.com/beanz/advent-of-code-go"
)

func Part1(p *ElfProg2016) int {
	return p.Run()
}

func Part2(p *ElfProg2016) int {
	p.Reg["c"] = 1
	return p.Run()
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	input := os.Args[1]
	elfProg := ReadElfProg2016(ReadLines(input))
	fmt.Printf("Part 1: %d\n", Part1(elfProg))
	elfProg = ReadElfProg2016(ReadLines(input))
	fmt.Printf("Part 2: %d\n", Part2(elfProg))
}
