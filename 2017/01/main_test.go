package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, 3, readGame("1122").Part1())
	assert.Equal(t, 4, readGame("1111").Part1())
	assert.Equal(t, 0, readGame("1234").Part1())
	assert.Equal(t, 9, readGame("91212129").Part1())
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 6, readGame("1212").Part2())
	assert.Equal(t, 0, readGame("1221").Part2())
	assert.Equal(t, 4, readGame("123425").Part2())
	assert.Equal(t, 12, readGame("123123").Part2())
	assert.Equal(t, 4, readGame("12131415").Part2())
}
