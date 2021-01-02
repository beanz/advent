package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestPart1(t *testing.T) {
	prog := ReadElfProg2016(ReadLines("test.txt"))
	assert.Equal(t, 3, Part1(prog))
	prog = ReadElfProg2016(ReadLines("input.txt"))
	assert.Equal(t, 12654, Part1(prog))
}

func TestPart2(t *testing.T) {
	prog := ReadElfProg2016(ReadLines("test.txt"))
	assert.Equal(t, 3, Part2(prog))
	//prog = ReadElfProg2016(ReadLines("input.txt"))
	//assert.Equal(t, 3, Part2(prog))
}
