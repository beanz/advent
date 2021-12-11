package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

type TestCase struct {
	in  string
	res int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{">", 2},
		{"^>v<", 4},
		{"^v^v^v^v^v", 2},
	}
	for _, tc := range tests {
		p1, _ := calc([]string{tc.in})
		assert.Equal(t, tc.res, p1, tc.in)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"^v", 3},
		{"^>v<", 3},
		{"^v^v^v^v^v", 11},
	}
	for _, tc := range tests {
		_, p2 := calc([]string{tc.in})
		assert.Equal(t, tc.res, p2, tc.in)
	}
}

func TestInput(t *testing.T) {
	p1, p2 := calc(ReadFileLines("input.txt"))
	assert.Equal(t, 2572, p1, "Part 1 on input.txt")
	assert.Equal(t, 2631, p2, "Part 2 on input.txt")
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
