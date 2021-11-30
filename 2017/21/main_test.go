package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestPlay(t *testing.T) {
	assert.Equal(t, 12, NewGame(ReadLines("test.txt")).Play(2))
}

func TestPart1(t *testing.T) {
	assert.Equal(t, 125, NewGame(ReadLines("input.txt")).Part1())
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 1782917, NewGame(ReadLines("input.txt")).Part2())
}
