package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, 5587, NewGame(ReadLines("test.txt")).Part1(10000))
	assert.Equal(t, 5240, NewGame(ReadLines("input.txt")).Part1(10000))
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 26, NewGame(ReadLines("test.txt")).Part2(100))
	assert.Equal(t, 2511944, NewGame(ReadLines("test.txt")).Part2(10000000))
	assert.Equal(t, 2512144, NewGame(ReadLines("input.txt")).Part2(10000000))
}
