package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, int64(325), NewGame(ReadLines("test.txt")).Part1())
	assert.Equal(t, int64(2049), NewGame(ReadLines("input.txt")).Part1())
}

func TestPart2(t *testing.T) {
	assert.Equal(t, int64(2300000000006), NewGame(ReadLines("input.txt")).Part2())
}
