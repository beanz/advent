package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent-of-code-go"
)

type SeatTestCase struct {
	plan string
	ans  int
}

func TestSeatID(t *testing.T) {
	tests := []SeatTestCase{
		{"FBFBBFFRLR", 357},
		{"BFFFBBFRRR", 567},
		{"FFFBBBFRRR", 119},
		{"BBFFBBFRLL", 820},
	}
	for _, tc := range tests {
		r := SeatID(tc.plan)
		assert.Equal(t, tc.ans, r)
	}
}

type TestCase struct {
	file string
	ans  int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 820},
		{"input.txt", 947},
	}
	for _, tc := range tests {
		r := NewSeatPlan(ReadLines(tc.file)).Part1()
		assert.Equal(t, tc.ans, r)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"input.txt", 636},
	}
	for _, tc := range tests {
		r := NewSeatPlan(ReadLines(tc.file)).Part2()
		assert.Equal(t, tc.ans, r)
	}
}