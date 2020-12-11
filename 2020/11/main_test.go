package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	aoc "github.com/beanz/advent-of-code-go"
)

type TestCase struct {
	file string
	ans  int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 37},
		{"input.txt", 2481},
	}
	for _, tc := range tests {
		r := NewMap(aoc.ReadLines(tc.file)).Part1()
		assert.Equal(t, tc.ans, r)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 26},
		{"input.txt", 2227},
	}
	for _, tc := range tests {
		r := NewMap(aoc.ReadLines(tc.file)).Part2()
		assert.Equal(t, tc.ans, r)
	}
}
