package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

type TestCase struct {
	file string
	ans  int64
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 7},
		{"input.txt", 169},
	}
	for _, tc := range tests {
		r := NewMap(ReadLines(tc.file)).Part1()
		assert.Equal(t, tc.ans, r)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 336},
		{"input.txt", 7560370818},
	}
	for _, tc := range tests {
		r := NewMap(ReadLines(tc.file)).Part2()
		assert.Equal(t, tc.ans, r)
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
