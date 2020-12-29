package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent2015/lib"
)

type TestCase struct {
	file string
	num  int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 605},
		{"input.txt", 251},
	}
	for _, tc := range tests {
		r := NewRoutes(ReadFileLines(tc.file))
		assert.Equal(t, tc.num, r.Part1(), "part 1: "+tc.file)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 982},
		{"input.txt", 898},
	}
	for _, tc := range tests {
		r := NewRoutes(ReadFileLines(tc.file))
		assert.Equal(t, tc.num, r.Part2(), "part 2: "+tc.file)
	}
}
