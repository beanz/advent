package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent2015/lib"
)

type TestCase struct {
	in  string
	res int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"2x3x4", 58},
		{"1x1x10", 43},
	}
	for _, tc := range tests {
		p1, _ := calc([]string{tc.in})
		assert.Equal(t, tc.res, p1, tc.in)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"2x3x4", 34},
		{"1x1x10", 14},
	}
	for _, tc := range tests {
		_, p2 := calc([]string{tc.in})
		assert.Equal(t, tc.res, p2, tc.in)
	}
}

func TestInput(t *testing.T) {
	p1, p2 := calc(ReadFileLines("input.txt"))
	assert.Equal(t, 1598415, p1, "Part 1 on input.txt")
	assert.Equal(t, 3812909, p2, "Part 2 on input.txt")
}
