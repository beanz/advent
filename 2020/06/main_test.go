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
		{"test1.txt", 11},
		{"input.txt", 6506},
	}
	for _, tc := range tests {
		r := NewDec(ReadChunks(tc.file)).Part1()
		assert.Equal(t, tc.ans, r)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 6},
		{"input.txt", 3243},
	}
	for _, tc := range tests {
		r := NewDec(ReadChunks(tc.file)).Part2()
		assert.Equal(t, tc.ans, r)
	}
}
