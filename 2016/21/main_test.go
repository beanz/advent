package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent-of-code-go"
)

func TestPart1(t *testing.T) {
	game := readGame(ReadLines("test.txt"))
	assert.Equal(t, "fbdecgha", game.Part1("abcdefgh"))
	game = readGame(ReadLines("input.txt"))
	assert.Equal(t, "gcedfahb", game.Part1("abcdefgh"))
}

func TestPart2(t *testing.T) {
	game := readGame(ReadLines("test.txt"))
	assert.Equal(t, "efghdabc", game.Part2("fbgdceah"))
	//game = readGame(ReadLines("input.txt"))
	//assert.Equal(t, "hegbdcfa", game.Part2("fbgdceah"))
}