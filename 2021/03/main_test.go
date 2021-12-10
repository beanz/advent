package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestPart1(t *testing.T) {
	tests := []struct {
		file string
		ans  int
	}{
		{"test1.txt", 198},
		{"input.txt", 749376},
	}
	for _, tc := range tests {
		assert.Equal(t,
			tc.ans, NewGame(ReadFileLines(tc.file)).Part1(), tc.file)
	}
}

func TestPart2(t *testing.T) {
	tests := []struct {
		file string
		ans  int
	}{
		{"test1.txt", 230},
		{"input.txt", 2372923},
	}
	for _, tc := range tests {
		assert.Equal(t,
			tc.ans, NewGame(ReadFileLines(tc.file)).Part2(), tc.file)
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
