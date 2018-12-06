package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent-of-code-go"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, 17, NewGame(ReadLines("test.txt")).Part1())
	assert.Equal(t, 6047, NewGame(ReadLines("input.txt")).Part1())
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 16, NewGame(ReadLines("test.txt")).Part2())
	assert.Equal(t, 46320, NewGame(ReadLines("input.txt")).Part2())
}
