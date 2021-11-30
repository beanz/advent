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
		{"test1.txt", 436},
		{"test2.txt", 1},
		{"test3.txt", 10},
		{"test4.txt", 27},
		{"test5.txt", 78},
		{"test6.txt", 438},
		{"test7.txt", 1836},
		{"input.txt", 260},
	}
	for _, tc := range tests {
		r := Part1(ReadIntsFromFile(tc.file))
		assert.Equal(t, tc.ans, r, tc.file)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 175594},
		{"test2.txt", 2578},
		{"test3.txt", 3544142},
		{"test4.txt", 261214},
		{"test5.txt", 6895259},
		{"test6.txt", 18},
		{"test7.txt", 362},
		{"input.txt", 950},
	}
	for _, tc := range tests {
		r := Part2(ReadIntsFromFile(tc.file))
		assert.Equal(t, tc.ans, r, tc.file)
	}
}
