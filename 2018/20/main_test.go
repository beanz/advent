package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, 3, NewGame(ReadLines("test-0.txt")).Part1())
	assert.Equal(t, 5, NewGame(ReadLines("test-1.txt")).Part1())
	assert.Equal(t, 10, NewGame(ReadLines("test-2.txt")).Part1())
	assert.Equal(t, 18, NewGame(ReadLines("test-3.txt")).Part1())
	assert.Equal(t, 23, NewGame(ReadLines("test-4.txt")).Part1())
	assert.Equal(t, 31, NewGame(ReadLines("test-5.txt")).Part1())
	assert.Equal(t, 3560, NewGame(ReadLines("input.txt")).Part1())
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 0, NewGame(ReadLines("test-0.txt")).Part2(7))
	assert.Equal(t, 0, NewGame(ReadLines("test-1.txt")).Part2(7))
	assert.Equal(t, 8, NewGame(ReadLines("test-2.txt")).Part2(7))
	assert.Equal(t, 18, NewGame(ReadLines("test-3.txt")).Part2(7))
	assert.Equal(t, 29, NewGame(ReadLines("test-4.txt")).Part2(7))
	assert.Equal(t, 42, NewGame(ReadLines("test-5.txt")).Part2(7))
	assert.Equal(t, 8688, NewGame(ReadLines("input.txt")).Part2(1000))
}
