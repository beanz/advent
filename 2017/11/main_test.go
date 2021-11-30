package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, 3, Part1("ne,ne,ne"))
	assert.Equal(t, 0, Part1("ne,ne,sw,sw"))
	assert.Equal(t, 2, Part1("ne,ne,s,s"))
	assert.Equal(t, 3, Part1("se,sw,se,sw,sw"))
	assert.Equal(t, 687, Part1(ReadLines("input.txt")[0]))
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 1483, Part2(ReadLines("input.txt")[0]))
}
