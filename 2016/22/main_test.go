package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent-of-code-go"
)

func TestPart1(t *testing.T) {
	game := readGame(ReadLines("input.txt"))
	assert.Equal(t, 888, game.Part1())
}

func TestPart2(t *testing.T) {
	game := readGame(ReadLines("input.txt"))
	assert.Equal(t, 236, game.Part2())
}
