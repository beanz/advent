package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	aoc "github.com/beanz/advent/lib-go"
)

type TestCase struct {
	file string
	p    int
	ans  int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 5, 127},
		{"input.txt", 25, 31161678},
	}
	for _, tc := range tests {
		int64s, _ := aoc.ReadInt64s(aoc.ReadLines(tc.file))
		r := Part1(int64s, int64(tc.p))
		assert.Equal(t, int64(tc.ans), r)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 127, 62},
		{"input.txt", 31161678, 5453868},
	}
	for _, tc := range tests {
		int64s, _ := aoc.ReadInt64s(aoc.ReadLines(tc.file))
		r := Part2(int64s, int64(tc.p))
		assert.Equal(t, int64(tc.ans), r)
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
