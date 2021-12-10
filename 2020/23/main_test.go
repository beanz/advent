package main

import (
	"fmt"
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

type TestCase1 struct {
	file  string
	moves uint
	ans   string
}

func (tc TestCase1) String() string {
	return fmt.Sprintf("%s moves=%d", tc.file, tc.moves)
}

func TestPart1(t *testing.T) {
	tests := []TestCase1{
		{"test1.txt", 0, "25467389"},
		{"test1.txt", 1, "54673289"},
		{"test1.txt", 10, "92658374"},
		{"test1.txt", 100, "67384529"},
		{"input.txt", 10, "92736584"},
		{"input.txt", 50, "63598274"},
		{"input.txt", 98, "46932785"},
		{"input.txt", 100, "46978532"},
	}
	for _, tc := range tests {
		assert.Equal(t,
			tc.ans, NewGame(ReadLines(tc.file)[0]).Part1(tc.moves),
			tc.String())
	}
}

type TestCase2 struct {
	file  string
	moves uint
	max   uint
	ans   uint
}

func (tc TestCase2) String() string {
	return fmt.Sprintf("%s moves=%d max=%d", tc.file, tc.moves, tc.max)
}

func TestPart2(t *testing.T) {
	tests := []TestCase2{
		{"test1.txt", 30, 20, 136},
		{"test1.txt", 100, 20, 54},
		{"test1.txt", 1000, 20, 42},
		{"test1.txt", 10000, 20, 285},
		{"test1.txt", 10001, 20, 285},
		{"test1.txt", 10, 1000000, 12},
		{"test1.txt", 100, 1000000, 12},
		{"test1.txt", 1000000, 1000000, 126},
		{"test1.txt", 2000000, 1000000, 32999175},
		{"test1.txt", 10000000, 1000000, 149245887792},
		{"input.txt", 10000000, 1000000, 163035127721},
	}
	for _, tc := range tests {
		assert.Equal(t,
			tc.ans, NewGame(ReadLines(tc.file)[0]).Part2(tc.moves, tc.max),
			tc.String())
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
