package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

type TestCase struct {
	file  string
	cards int64
	pos   int64
	res   int64
}

func TestForward(t *testing.T) {
	tests := []TestCase{
		TestCase{"test1a.txt", 10, 3, 6},
		TestCase{"test1a.txt", 10, 8, 1},
		TestCase{"test1b.txt", 10, 1, 8},
		TestCase{"test1b.txt", 10, 4, 1},
	}
	for _, tc := range tests {
		r := NewGame(ReadLines(tc.file), tc.cards).Forward(tc.pos)
		assert.Equal(t, tc.res, r)
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
