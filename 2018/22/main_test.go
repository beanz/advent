package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, 114, NewGame(ReadLines("test.txt")).Part1())
	assert.Equal(t, 10204, NewGame(ReadLines("input.txt")).Part1())
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 45, NewGame(ReadLines("test.txt")).Part2())
	//assert.Equal(t, 1004, NewGame(ReadLines("input.txt")).Part2())
}
