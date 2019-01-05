package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent-of-code-go"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, 5587, NewGame(ReadLines("test.txt")).Part1(10000))
	assert.Equal(t, 5240, NewGame(ReadLines("input.txt")).Part1(10000))
}
