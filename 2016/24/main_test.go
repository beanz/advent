package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestPart1(t *testing.T) {
	game := readGame(ReadLines("test.txt"))
	assert.Equal(t, 14, game.Part1())
	game = readGame(ReadLines("input.txt"))
	assert.Equal(t, 470, game.Part1())
}

func TestPart2(t *testing.T) {
	game := readGame(ReadLines("test.txt"))
	assert.Equal(t, 20, game.Part2())
	game = readGame(ReadLines("input.txt"))
	assert.Equal(t, 720, game.Part2())
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
