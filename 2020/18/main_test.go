package main

import (
	"fmt"
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

type TestCase struct {
	sum string
	ans int64
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"10", 10},
		{"2 + 3", 5},
		{"1 + 2 * 3 + 4 * 5 + 6", 71},
		{"1 + (2 * 3) + (4 * (5 + 6))", 51},
		{"2 * 3 + (4 * 5)", 26},
		{"5 + (8 * 3 + 9 + 3 * 4 * 3)", 437},
		{"5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))", 12240},
		{"((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", 13632},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, Part1Math(tc.sum), fmt.Sprintf("%s", tc.sum))
	}
	assert.Equal(t,
		int64(26457), Part1(ReadLines("test1.txt")), "file test1.txt")
	assert.Equal(t,
		int64(510009915468), Part1(ReadLines("input.txt")), "file input.txt")
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"1 + 2 * 3 + 4 * 5 + 6", 231},
		{"1 + (2 * 3) + (4 * (5 + 6))", 51},
		{"2 * 3 + (4 * 5)", 46},
		{"8 * 3 + 9 + 3 * 4 * 3", 1440},
		{"5 + (8 * 3 + 9 + 3 * 4 * 3)", 1445},
		{"5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))", 669060},
		{"((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", 23340},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, Part2Math(tc.sum), fmt.Sprintf("%s", tc.sum))
	}
	assert.Equal(t,
		int64(694173), Part2(ReadLines("test1.txt")), "file test1.txt")
	assert.Equal(t,
		int64(321176691637769), Part2(ReadLines("input.txt")),
		"file input.txt")
}
