package main

import (
	. "github.com/beanz/advent-of-code-go"
	"github.com/stretchr/testify/assert"
	"testing"
)

type TestCase struct {
	lines []string
	dist  int
	steps int
}

func TestPlay(t *testing.T) {
	lines := ReadLines("input.txt")
	tests := []TestCase{
		{[]string{"R8,U5,L5,D3", "U7,R6,D4,L4"}, 6, 30},
		{[]string{"R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51",
			"U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"}, 135, 410},
		{[]string{"R75,D30,R83,U83,L12,D49,R71,U7,L72",
			"U62,R66,U55,R34,D71,R55,D58,R83"}, 159, 610},
		{lines, 225, 35194},
	}
	for _, tc := range tests {
		d, s := Calc(tc.lines)
		assert.Equal(t, tc.dist, d)
		assert.Equal(t, tc.steps, s)
	}
}
