package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, "5158916779", NewGame(ReadLines("test-0a.txt")).Part1())
	assert.Equal(t, "0124515891", NewGame(ReadLines("test-1a.txt")).Part1())
	assert.Equal(t, "9251071085", NewGame(ReadLines("test-2a.txt")).Part1())
	assert.Equal(t, "5941429882", NewGame(ReadLines("test-3a.txt")).Part1())
	assert.Equal(t, "5371393113", NewGame(ReadLines("input.txt")).Part1())
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 9, NewGame(ReadLines("test-0b.txt")).Part2())
	assert.Equal(t, 5, NewGame(ReadLines("test-1b.txt")).Part2())
	assert.Equal(t, 18, NewGame(ReadLines("test-2b.txt")).Part2())
	assert.Equal(t, 2018, NewGame(ReadLines("test-3b.txt")).Part2())
	assert.Equal(t, 20286858, NewGame(ReadLines("input.txt")).Part2())
}
