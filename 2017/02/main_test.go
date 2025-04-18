package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestPart1(t *testing.T) {
	game := readGame(ReadLines("test1.txt"))
	assert.Equal(t, 18, game.Part1())
	game = readGame(ReadLines("input.txt"))
	assert.Equal(t, 47623, game.Part1())
}

func TestPart2(t *testing.T) {
	game := readGame(ReadLines("test2.txt"))
	assert.Equal(t, 9, game.Part2())
	game = readGame(ReadLines("input.txt"))
	assert.Equal(t, 312, game.Part2())
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
