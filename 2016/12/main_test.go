package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent-of-code-go"
)

func TestPart1(t *testing.T) {
	prog := ReadElfProg2016(ReadLines("test.txt"))
	assert.Equal(t, 42, Part1(prog))
	prog = ReadElfProg2016(ReadLines("input.txt"))
	assert.Equal(t, 318007, Part1(prog))
}

func TestPart2(t *testing.T) {
	prog := ReadElfProg2016(ReadLines("test.txt"))
	assert.Equal(t, 42, Part2(prog))
	prog = ReadElfProg2016(ReadLines("input.txt"))
	assert.Equal(t, 9227661, Part2(prog))
}