package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestPart1(t *testing.T) {
	g := Play(ReadLines("test.txt"))
	assert.Equal(t, 6, g.Part1())
	g = Play(ReadLines("input.txt"))
	assert.Equal(t, 288, g.Part1())
}

func TestPart2(t *testing.T) {
	g := Play(ReadLines("test.txt"))
	assert.Equal(t, 2, g.Part2())
	g = Play(ReadLines("input.txt"))
	assert.Equal(t, 211, g.Part2())
}
