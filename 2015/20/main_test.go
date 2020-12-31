package main

import (
	"fmt"
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent2015/lib"
)

type TestCase struct {
	house int
	part2 bool
	num   int
}

func TestNumPres(t *testing.T) {
	tests := []TestCase{
		{1, false, 10},
		{2, false, 30},
		{3, false, 40},
		{4, false, 70},
		{5, false, 60},
		{6, false, 120},
		{7, false, 80},
		{8, false, 150},
		{9, false, 130},
		{1, true, 11},
		{2, true, 33},
		{3, true, 44},
		{4, true, 77},
		{5, true, 66},
		{6, true, 132},
		{7, true, 88},
		{8, true, 165},
		{9, true, 143},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.num, NumPresents(tc.house, tc.part2),
			fmt.Sprintf("num presents: %d %v", tc.house, tc.part2))
	}
}

func TestPart1(t *testing.T) {
	assert.Equal(t, 665280, calc(ReadFileInts("input.txt")[0], false),
		"part 1")
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 705600, calc(ReadFileInts("input.txt")[0], true),
		"part 2")
}
