package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestPart1(t *testing.T) {
	g := NewGame(5, false)
	assert.Equal(t, 3, g.Part1())
	g = NewGame(100, false)
	assert.Equal(t, 73, g.Part1())
}

func TestPart2(t *testing.T) {
	g := NewGame(5, false)
	assert.Equal(t, 2, g.Part2())
	g = NewGame(100, false)
	assert.Equal(t, 19, g.Part2())
}
