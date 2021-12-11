package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

type TestCase struct {
	file string
	exp  int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 4},
		{"test2.txt", 7},
		{"input.txt", 576},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.exp,
			NewMach(ReadFileChunks(tc.file)).Part1(),
			"part 1: "+tc.file)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 3},
		{"test2.txt", 6},
		{"input.txt", 207},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.exp,
			NewMach(ReadFileChunks(tc.file)).Part2(),
			"part 2: "+tc.file)
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
