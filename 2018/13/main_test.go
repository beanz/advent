package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent-of-code-go"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, "7,3", NewGame(ReadLines("test-1.txt")).Part1())
	assert.Equal(t, "116,91", NewGame(ReadLines("input.txt")).Part1())
}

func TestPart2(t *testing.T) {
	assert.Equal(t, "6,4", NewGame(ReadLines("test-2.txt")).Part2())
	assert.Equal(t, "8,23", NewGame(ReadLines("input.txt")).Part2())
}
