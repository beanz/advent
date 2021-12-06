package main

import (
	"fmt"
	. "github.com/beanz/advent/lib-go"
)

type School struct {
	init []int
}

func NewSchool(in []int) *School {
	return &School{in}
}

func (s *School) Fish(days int) int {
	fish := make([]int, 9)
	for _, t := range s.init {
		fish[t]++
	}

	for d := 1; d <= days; d++ {
		next := make([]int, 9)
		next[6] = fish[0]
		next[8] = fish[0]
		for i := 0; i < 8; i++ {
			next[i] += fish[i+1]
		}
		fish = next
	}
	return Sum(fish...)
}

func (s *School) Part1() int {
	return s.Fish(80)
}

func (s *School) Part2() int {
	return s.Fish(256)
}

func main() {
	inp := ReadInputInts()
	s := NewSchool(inp)
	fmt.Printf("Part 1: %d\n", s.Part1())
	fmt.Printf("Part 2: %d\n", s.Part2())
}
