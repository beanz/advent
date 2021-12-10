package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func runscript(prog []int, script string) int {
	ic := NewIntCodeFromASCII(prog, script)
	output := ic.RunToHalt()
	s := ""
	for _, ch := range output {
		if ch > 127 {
			return ch
		}
		s += string(rune(ch))
	}
	fmt.Print(s)
	return -1
}

func part1(prog []int) int {
	// (!C && D) || !A
	return runscript(prog, "NOT C J\nAND D J\nNOT A T\nOR T J\nWALK\n")
}

func part2(prog []int) int {
	// (!A || ( (!B || !C) && H ) ) && D
	return runscript(prog,
		"NOT B T\nNOT C J\nOR J T\nAND H T\nNOT A J\nOR T J\nAND D J\nRUN\n")
}

func main() {
	lines := InputLines(input)
	prog := SimpleReadInts(lines[0])
	p1 := part1(prog)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := part2(prog)
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
