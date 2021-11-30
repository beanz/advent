package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	aoc "github.com/beanz/advent/lib-go"
)

type TestCase struct {
	file string
	ans  int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 25},
		{"input.txt", 759},
	}
	for _, tc := range tests {
		r := NewNav(aoc.ReadLines(tc.file)).Part1()
		assert.Equal(t, tc.ans, r)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 286},
		{"input.txt", 45763},
	}
	for _, tc := range tests {
		r := NewNav(aoc.ReadLines(tc.file)).Part2()
		assert.Equal(t, tc.ans, r)
	}
}
