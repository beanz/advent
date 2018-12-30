package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, 1, NewCPU("test.txt").Part1())
	assert.Equal(t, 3745, NewCPU("input.txt").Part1())
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 10, NewCPU("test.txt").Part2())
	assert.Equal(t, 4644, NewCPU("input.txt").Part2())
}
