package main

import (
	"testing"

	"github.com/stretchr/testify/assert"

	. "github.com/beanz/advent/lib-go"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, 57, NewGame(ReadLines("test.txt")).Part1())
	assert.Equal(t, 56, NewGame(ReadLines("test2.txt")).Part1())
	assert.Equal(t, 36790, NewGame(ReadLines("input.txt")).Part1())
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 29, NewGame(ReadLines("test.txt")).Part2())
	assert.Equal(t, 29, NewGame(ReadLines("test2.txt")).Part2())
	assert.Equal(t, 30765, NewGame(ReadLines("input.txt")).Part2())
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
