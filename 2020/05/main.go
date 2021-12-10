package main

import (
	_ "embed"
	"fmt"
	"math"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func SeatID(l string) int {
	s := 0
	sm := 1024
	for _, ch := range l {
		switch ch {
		case 'F', 'L':
			sm /= 2
		case 'B', 'R':
			sm /= 2
			s += sm
		}
	}
	return s
}

type SeatPlan struct {
	seats map[int]bool
	max   int
}

func NewSeatPlan(lines []string) *SeatPlan {
	max := math.MinInt32
	seats := make(map[int]bool, len(lines))
	for _, l := range lines {
		s := SeatID(l)
		seats[s] = true
		if s > max {
			max = s
		}
	}
	return &SeatPlan{seats, max}
}

func (s *SeatPlan) Part1() int {
	return s.max
}

func (s *SeatPlan) Part2() int {
	for k := range s.seats {
		if !s.seats[k-1] && s.seats[k-2] {
			return k - 1
		}
	}
	return 0
}

func main() {
	lines := InputLines(input)
	sp := NewSeatPlan(lines)
	p1 := sp.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := sp.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
