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
		{"test1.txt", 4},
		{"test2.txt", 0},
		{"input.txt", 112},
	}
	for _, tc := range tests {
		r := NewBS(ReadLines(tc.file)).Part1()
		assert.Equal(t, tc.ans, r)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 32},
		{"test2.txt", 126},
		{"input.txt", 6260},
	}
	for _, tc := range tests {
		r := NewBS(ReadLines(tc.file)).Part2()
		assert.Equal(t, tc.ans, r)
	}
}
