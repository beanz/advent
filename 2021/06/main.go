package main

import (
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type School struct {
	init []byte
}

func NewSchool(in []byte) *School {
	return &School{FastBytes(in)}
}

func (s *School) Fish(d1, d2 int) (int, int) {
	fish := make([]int, 9)
	for _, t := range s.init {
		fish[t]++
	}

	for d := 1; d <= d1; d++ {
		z := fish[0]
		for i := 0; i < 8; i++ {
			fish[i] = fish[i+1]
		}
		fish[6] += z
		fish[8] = z
	}
	p1 := Sum(fish...)
	for d := d1 + 1; d <= d2; d++ {
		z := fish[0]
		for i := 0; i < 8; i++ {
			fish[i] = fish[i+1]
		}
		fish[6] += z
		fish[8] = z
	}
	return p1, Sum(fish...)
}

func main() {
	s := NewSchool(InputBytes(input))
	p1, p2 := s.Fish(80, 256)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
