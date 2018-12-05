package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent-of-code-go"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, 10, NewGame(ReadLines("test.txt")).Part1())
	assert.Equal(t, 11264, NewGame(ReadLines("input.txt")).Part1())
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 4, NewGame(ReadLines("test.txt")).Part2())
	assert.Equal(t, 4552, NewGame(ReadLines("input.txt")).Part2())
}
