package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent-of-code-go"
)

type TestCase struct {
	file string
	ans  int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 2},
		{"input.txt", 454},
	}
	for _, tc := range tests {
		r := NewDB(ReadLines(tc.file)).Part1()
		assert.Equal(t, tc.ans, r)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 1},
		{"input.txt", 649},
	}
	for _, tc := range tests {
		r := NewDB(ReadLines(tc.file)).Part2()
		assert.Equal(t, tc.ans, r)
	}
}
