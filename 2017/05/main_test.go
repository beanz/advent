package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, 5, NewProg("test.txt").Part1())
	assert.Equal(t, 355965, NewProg("input.txt").Part1())
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 10, NewProg("test.txt").Part2())
	assert.Equal(t, 26948068, NewProg("input.txt").Part2())
}
