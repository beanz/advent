package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent2015/lib"
)

type TestCase struct {
	in  string
	et  int
	res int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 1000, 1120},
		{"input.txt", 2503, 2655},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.res, Part1(ReadFileLines(tc.in), tc.et),
			"Part 1: "+tc.in)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 1000, 689},
		{"input.txt", 2503, 1059},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.res, Part2(ReadFileLines(tc.in), tc.et),
			"Part 2: "+tc.in)
	}
}
