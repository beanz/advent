package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, 240, NewGame(ReadLines("test.txt")).Part1())
	assert.Equal(t, 71748, NewGame(ReadLines("input.txt")).Part1())
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 4455, NewGame(ReadLines("test.txt")).Part2())
	assert.Equal(t, 106850, NewGame(ReadLines("input.txt")).Part2())
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
