package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	aoc "github.com/beanz/advent/lib-go"
)

type TestCase struct {
	file string
	ans  int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 5},
		{"input.txt", 1614},
	}
	for _, tc := range tests {
		r := NewHH(aoc.ReadLines(tc.file)).Part1()
		assert.Equal(t, tc.ans, r)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 8},
		{"input.txt", 1260},
	}
	for _, tc := range tests {
		r := NewHH(aoc.ReadLines(tc.file)).Part2()
		assert.Equal(t, tc.ans, r)
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
