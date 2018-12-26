package main

import (
	. "github.com/beanz/advent-of-code-go"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestIsAligned(t *testing.T) {
	assert.True(t, Disc{1, 5, 4}.IsAligned(0))
	assert.False(t, Disc{1, 5, 4}.IsAligned(1))
	assert.True(t, Disc{1, 5, 4}.IsAligned(5))

	assert.False(t, Disc{2, 2, 1}.IsAligned(0))
	assert.True(t, Disc{2, 2, 1}.IsAligned(1))
	assert.True(t, Disc{2, 2, 1}.IsAligned(5))
}

func TestPart1(t *testing.T) {
	game := readGame(ReadLines("test.txt"))
	assert.Equal(t, 5, game.Part1())
	game = readGame(ReadLines("input.txt"))
	assert.Equal(t, 203660, game.Part1())
}

func TestPart2(t *testing.T) {
	game := readGame(ReadLines("test.txt"))
	assert.Equal(t, 15, game.Part2())
	game = readGame(ReadLines("input.txt"))
	assert.Equal(t, 2408135, game.Part2())
}
