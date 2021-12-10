package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, 0, NewGame(ReadLines("test.txt")).Part1())
	assert.Equal(t, 91, NewGame(ReadLines("input.txt")).Part1())
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 1, NewGame(ReadLines("test-2.txt")).Part2())
	assert.Equal(t, 567, NewGame(ReadLines("input.txt")).Part2())
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
