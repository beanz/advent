package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

type TestCase struct {
	file string
	ans  int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 15},
		{"input.txt", 456},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, NewLavaTubes(ReadLines(tc.file)).Part1(), tc.file)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 1134},
		{"input.txt", 1047744},
	}
	for _, tc := range tests {
		lt := NewLavaTubes(ReadLines(tc.file))
		lt.Part1()
		assert.Equal(t, tc.ans, lt.Part2(), tc.file)
	}
}
