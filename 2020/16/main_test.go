package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

type TestCase struct {
	file string
	ans  int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 71},
		{"input.txt", 21980},
	}
	for _, tc := range tests {
		m := NewMess(ReadLines(tc.file))
		assert.Equal(t, tc.ans, m.error)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test2.txt", 1716},
		{"input.txt", 1439429522627},
	}
	for _, tc := range tests {
		m := NewMess(ReadLines(tc.file))
		if tc.file == "test2.txt" {
			m.onlyDepart = false
		}
		assert.Equal(t, tc.ans, m.Solve())
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
