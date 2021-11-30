package main

import (
	"fmt"
	"log"
	"os"

	. "github.com/beanz/advent/lib-go"
)

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
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	changes := ReadInput(os.Args[1])
	fmt.Printf("Part 1: %d\n", Part1(changes))
	fmt.Printf("Part 2: %d\n", Part2(changes))
}
