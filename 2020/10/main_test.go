package main

import (
	"github.com/stretchr/testify/assert"
	"sort"
	"testing"

	aoc "github.com/beanz/advent/lib-go"
)

type TestCase struct {
	file string
	ans  int64
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test0.txt", 8},
		{"test1.txt", 35},
		{"test2.txt", 220},
		{"input.txt", 1920},
	}
	for _, tc := range tests {
		ints := aoc.ReadIntsFromFile(tc.file)
		sort.Ints(ints)
		r := Part1(ints)
		assert.Equal(t, int(tc.ans), r)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test0.txt", 4},
		{"test1.txt", 8},
		{"test2.txt", 19208},
		{"input.txt", 1511207993344},
	}
	for _, tc := range tests {
		ints := aoc.ReadIntsFromFile(tc.file)
		sort.Ints(ints)
		r := Part2(ints)
		assert.Equal(t, tc.ans, r)
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
