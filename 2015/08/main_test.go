package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent2015/lib"
)

type TestCaseCount struct {
	s   string
	num int
}

func TestCount1(t *testing.T) {
	tests := []TestCaseCount{
		{"\"\"", 2 - 0},
		{"\"abc\"", 5 - 3},
		{"\"aaa\\\"aaa\"", 10 - 7},
		{"\"\\x27\"", 6 - 1},
		{"\"h\\\\\"", 5 - 2},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.num, Count1(tc.s), "count 1: "+tc.s)
	}
}

func TestCount2(t *testing.T) {
	tests := []TestCaseCount{
		{"\"\"", 6 - 2},
		{"\"abc\"", 9 - 5},
		{"\"aaa\\\"aaa\"", 16 - 10},
		{"\"\\x27\"", 11 - 6},
		{"\"h\\\\\"", 11 - 5},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.num, Count2(tc.s), "count 2: "+tc.s)
	}
}

type TestCase struct {
	file string
	num  int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 23 - 11},
		{"input.txt", 1342},
	}
	for _, tc := range tests {
		in := ReadFileLines(tc.file)
		assert.Equal(t, tc.num, Part1(in), "part 1: "+tc.file)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 42 - 23},
		{"input.txt", 2074},
	}
	for _, tc := range tests {
		in := ReadFileLines(tc.file)
		assert.Equal(t, tc.num, Part2(in), "part 2: "+tc.file)
	}
}
