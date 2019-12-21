package main

import (
	"fmt"
	"log"
	"os"

	. "github.com/beanz/advent-of-code-go"
)

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
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	prog := SimpleReadInts(lines[0])
	fmt.Printf("Part 1: %d\n", part1(prog))
	fmt.Printf("Part 2: %d\n", part2(prog))
}
