package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	aoc "github.com/beanz/advent-of-code-go"
)

type TestCase struct {
	file string
	p    int
	ans  int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 5, 127},
		{"input.txt", 25, 31161678},
	}
	for _, tc := range tests {
		r := Part1(aoc.ReadIntsFromFile(tc.file), tc.p)
		assert.Equal(t, tc.ans, r)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 127, 62},
		{"input.txt", 31161678, 5453868},
	}
	for _, tc := range tests {
		r := Part2(aoc.ReadIntsFromFile(tc.file), tc.p)
		assert.Equal(t, tc.ans, r)
	}
}
