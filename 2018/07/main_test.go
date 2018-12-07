package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent-of-code-go"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, "CABDFE", NewGame(ReadLines("test.txt")).Part1())
	assert.Equal(t, "BETUFNVADWGPLRJOHMXKZQCISY",
		NewGame(ReadLines("input.txt")).Part1())
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 15, NewGame(ReadLines("test.txt")).Part2())
	assert.Equal(t, 848, NewGame(ReadLines("input.txt")).Part2())
}
