package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, 5, NewMem("test.txt").Part1())
	assert.Equal(t, 5042, NewMem("input.txt").Part1())
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 4, NewMem("test.txt").Part2())
	assert.Equal(t, 1086, NewMem("input.txt").Part2())
}
