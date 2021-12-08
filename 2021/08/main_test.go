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

func TestStringPerm(t *testing.T) {
	tests := []struct {
		perm string
		ans  string
	}{
		{perm: "abcdefg", ans: "abcdefgabc"},
		{perm: "bcdefga", ans: "bcdefgabcd"},
	}
	for _, tc := range tests {
		p := StringPerm{tc.perm}
		assert.Equal(t, tc.ans, p.Permute("abcdefgabc"))
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
		assert.Equal(t, tc.ans, Digit(tc.s))
	}
}

func TestStringPerms(t *testing.T) {
	tests := []struct {
		s   string
		len int
		ans []StringPerm
	}{
		{
			s: "ab", len: 2,
			ans: []StringPerm{StringPerm{"ba"}, StringPerm{"ab"}},
		},
		{
			s: "abc", len: 6,
			ans: []StringPerm{StringPerm{s: "cba"}, StringPerm{s: "bca"}, StringPerm{s: "bac"}, StringPerm{s: "cab"}, StringPerm{s: "acb"}, StringPerm{s: "abc"}},
		},
		{s: "abcdefg", len: 5040},
	}
	for _, tc := range tests {
		sp := StringPerms(tc.s)
		assert.Equal(t, tc.len, len(sp))
		if tc.len < 100 {
			assert.Equal(t, tc.ans, sp)
		}
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
