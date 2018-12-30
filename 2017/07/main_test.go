package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, "tknk", NewTower("test.txt").Part1())
	assert.Equal(t, "eqgvf", NewTower("input.txt").Part1())
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 60, NewTower("test.txt").Part2())
	assert.Equal(t, 757, NewTower("input.txt").Part2())
}
