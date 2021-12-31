package main

import (
	_ "embed"
	assert "github.com/stretchr/testify/require"
	"testing"
)

//go:embed test0.txt
var test0 []byte

//go:embed test1.txt
var test1 []byte

//go:embed test2.txt
var test2 []byte

type TestCase struct {
	file string
	data []byte
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
		assert.Equal(t, tc.ans, int(NewSegments([]byte(tc.s))))
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
		assert.Equal(t, tc.ans, NewSegments([]byte(tc.s)).Digit())
	}
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test0.txt", test0, 2},
		{"test1.txt", test1, 26},
		{"test2.txt", test2, 0},
		{"input.txt", input, 504},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, NewNotes(tc.data).Part1(), tc.file)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test0.txt", test0, 8394},
		{"test1.txt", test1, 61229},
		{"test2.txt", test2, 5353},
		{"input.txt", input, 1073431},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, NewNotes(tc.data).Part2(), tc.file)
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
