package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Part1(changes []int) int {
	s := 0
	for _, c := range changes {
		s += c
	}
	return s
}

func Part2(changes []int) int {
	s := 0
	m := make(map[int]bool)

	for {
		for _, c := range changes {
			s += c
			if _, ok := m[s]; ok {
				return s
			}
			m[s] = true
		}
	}
}

func ReadInput(file string) []int {
	lines := ReadLines(file)
	return ReadInts(lines)
}

func main() {
	changes := Ints(InputString(input))
	p1 := Part1(changes)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := Part2(changes)
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
