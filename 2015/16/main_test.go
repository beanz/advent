package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

type TestCase struct {
	file string
	num  int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"input.txt", 103},
	}
	for _, tc := range tests {
		sues := NewSues(ReadFileLines(tc.file))
		assert.Equal(t, tc.num, sues.Part1(), "part 1: "+tc.file)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"input.txt", 405},
	}
	for _, tc := range tests {
		sues := NewSues(ReadFileLines(tc.file))
		assert.Equal(t, tc.num, sues.Part2(), "part 2: "+tc.file)
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
