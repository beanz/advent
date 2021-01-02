package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
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
		{"test1.txt", 57600000},
		{"input.txt", 11171160},
	}
	for _, tc := range tests {
		r := NewRecipe(ReadFileLines(tc.file))
		assert.Equal(t, tc.num, r.Part2(), "part 2: "+tc.file)
	}
}
