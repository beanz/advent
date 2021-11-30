package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, 1147, NewGame(ReadLines("test.txt")).Part1())
	assert.Equal(t, 505895, NewGame(ReadLines("input.txt")).Part1())
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 0, NewGame(ReadLines("test.txt")).Part2())
	assert.Equal(t, 139590, NewGame(ReadLines("input.txt")).Part2())
}
