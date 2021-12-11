package main

import (
	"fmt"
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

type TestCase struct {
	file   string
	rounds int
	exp    int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 1, 11},
		{"test1.txt", 4, 4},
		{"input.txt", 100, 821},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.exp,
			NewLife(ReadFileLines(tc.file)).Part1(tc.rounds),
			fmt.Sprintf("part 1: %s x %d", tc.file, tc.rounds))
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 1, 18},
		{"test1.txt", 4, 17},
		{"input.txt", 100, 886},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.exp,
			NewLife(ReadFileLines(tc.file)).Part2(tc.rounds),
			fmt.Sprintf("part 2: %s x %d", tc.file, tc.rounds))
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
