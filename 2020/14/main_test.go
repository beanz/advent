package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent-of-code-go"
)

type TestCase struct {
	file string
	ans  int64
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 165},
		{"test2.txt", 51},
		{"input.txt", 4297467072083},
	}
	for _, tc := range tests {
		r := Part1(ReadLines(tc.file))
		assert.Equal(t, tc.ans, r)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", -1},
		{"test2.txt", 208},
		{"input.txt", 5030603328768},
	}
	for _, tc := range tests {
		r := Part2(ReadLines(tc.file), tc.file)
		assert.Equal(t, tc.ans, r)
	}
}
