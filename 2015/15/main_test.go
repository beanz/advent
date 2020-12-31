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
		{"test1.txt", 62842880},
		{"input.txt", 13882464},
	}
	for _, tc := range tests {
		r := NewRecipe(ReadFileLines(tc.file))
		assert.Equal(t, tc.num, r.Part1(), "part 1: "+tc.file)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 11171160},
		{"input.txt", 57600000},
	}
	for _, tc := range tests {
		r := NewRecipe(ReadFileLines(tc.file))
		assert.Equal(t, tc.num, r.Part2(), "part 2: "+tc.file)
	}
}
