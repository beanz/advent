package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent-of-code-go"
)

type TestCase1 struct {
	file string
	ans  int
}

func TestPart1(t *testing.T) {
	tests := []TestCase1{
		{"test1.txt", 5},
		{"input.txt", 2874},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, NewMenu(ReadLines(tc.file)).Part1(), tc.file)
	}
}

type TestCase2 struct {
	file string
	ans  string
}

func TestPart2(t *testing.T) {
	tests := []TestCase2{
		{"test1.txt", "mxmxvkd,sqjhc,fvjkl"},
		{"input.txt", "gfvrr,ndkkq,jxcxh,bthjz,sgzr,mbkbn,pkkg,mjbtz"},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, NewMenu(ReadLines(tc.file)).Part2(), tc.file)
	}
}
