package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestLoopSize(t *testing.T) {
	assert.Equal(t, int64(8), LoopSize(5764801))
	assert.Equal(t, int64(11), LoopSize(17807724))
	assert.Equal(t, int64(13467729), LoopSize(9033205))
	assert.Equal(t, int64(3020524), LoopSize(9281649))
}

type TestCase struct {
	file string
	ans  string
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", "14897079"},
		{"input.txt", "9714832"},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, Part1(ReadLines(tc.file)), tc.file)
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
