package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestPart1(t *testing.T) {
	game := readGame(ReadLines("input.txt"))
	assert.Equal(t, 888, game.Part1())
	game = readGame(ReadLines("input2.txt"))
	assert.Equal(t, 1003, game.Part1())
}

func TestPart2(t *testing.T) {
	game := readGame(ReadLines("input.txt"))
	assert.Equal(t, 236, game.Part2())
	game = readGame(ReadLines("input2.txt"))
	assert.Equal(t, 192, game.Part2())
}
