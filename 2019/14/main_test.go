package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

type TestCase struct {
	file string
	res  int
	res2 int
}

func TestParts(t *testing.T) {
	tests := []TestCase{
		{"test1a.txt", 31, 34482758620},
		{"test1b.txt", 165, 6323777403},
		{"test1c.txt", 13312, 82892753},
		{"test1d.txt", 180697, 5586022},
		{"test1e.txt", 2210736, 460664},
		{"input.txt", 598038, 2269325},
	}
	for _, tc := range tests {
		res := NewFactory(ReadLines(tc.file)).Part1()
		assert.Equal(t, tc.res, res)
		res2 := NewFactory(ReadLines(tc.file)).Part2()
		assert.Equal(t, tc.res2, res2)
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
