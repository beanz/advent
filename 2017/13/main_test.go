package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, 24, NewFirewall(ReadLines("test.txt")).Part1())
	assert.Equal(t, 1928, NewFirewall(ReadLines("input.txt")).Part1())
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 10, NewFirewall(ReadLines("test.txt")).Part2())
	assert.Equal(t, 3830344, NewFirewall(ReadLines("input.txt")).Part2())
}
