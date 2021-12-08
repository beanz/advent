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

func TestSegments(t *testing.T) {
	tests := []struct {
		s   string
		ans int
	}{
		{s: "a", ans: 1},
		{s: "b", ans: 2},
		{s: "c", ans: 4},
		{s: "abcdefg", ans: 127},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, int(NewSegments(tc.s)))
	}
}

func TestDigit(t *testing.T) {
	tests := []struct {
		s   string
		ans int
	}{
		{s: "abcefg", ans: 0},
		{s: "cf", ans: 1},
		{s: "acdeg", ans: 2},
		{s: "acdfg", ans: 3},
		{s: "bcdf", ans: 4},
		{s: "abdfg", ans: 5},
		{s: "abdefg", ans: 6},
		{s: "acf", ans: 7},
		{s: "abcdefg", ans: 8},
		{s: "abcdfg", ans: 9},
		{s: "", ans: -1},
		{s: "ab", ans: -1},
		{s: "gedca", ans: 2},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, NewSegments(tc.s).Digit())
	}
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test0.txt", 2},
		{"test1.txt", 26},
		{"test2.txt", 0},
		{"input.txt", 504},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, NewNotes(ReadLines(tc.file)).Part1(), tc.file)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test0.txt", 8394},
		{"test1.txt", 61229},
		{"test2.txt", 5353},
		{"input.txt", 1073431},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, NewNotes(ReadLines(tc.file)).Part2(), tc.file)
	}
}
