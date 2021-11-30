package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, 2129920, NewGame1(ReadLines("test.txt")).Part1())
	assert.Equal(t, 6520863, NewGame1(ReadLines("input.txt")).Part1())
}

func TestNeighbours(t *testing.T) {
	assert.Equal(t, 4, len(neighbours(0, 3, 3)))
	assert.Equal(t, 4, len(neighbours(1, 1, 1)))
	assert.Equal(t, 4, len(neighbours(1, 3, 0)))
	assert.Equal(t, 4, len(neighbours(1, 4, 0)))
	assert.Equal(t, 8, len(neighbours(0, 3, 2)))
	assert.Equal(t, 8, len(neighbours(1, 3, 2)))
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 99, NewGame2(ReadLines("test.txt")).Part2(10))
	assert.Equal(t, 1970, NewGame2(ReadLines("input.txt")).Part2(200))
}
