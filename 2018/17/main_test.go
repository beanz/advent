package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent-of-code-go"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, 57, NewGame(ReadLines("test.txt")).Part1())
	assert.Equal(t, 56, NewGame(ReadLines("test-2.txt")).Part1())
	assert.Equal(t, 36790, NewGame(ReadLines("input.txt")).Part1())
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 29, NewGame(ReadLines("test.txt")).Part2())
	assert.Equal(t, 29, NewGame(ReadLines("test-2.txt")).Part2())
	assert.Equal(t, 30765, NewGame(ReadLines("input.txt")).Part2())
}