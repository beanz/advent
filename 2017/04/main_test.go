package main

import (
	"github.com/stretchr/testify/assert"
	"strings"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestIsValid(t *testing.T) {
	assert.True(t, IsValid(strings.Split("aa bb cc dd ee", " ")))
	assert.False(t, IsValid(strings.Split("aa bb cc dd aa", " ")))
	assert.True(t, IsValid(strings.Split("aa bb cc dd aaa", " ")))
}

func TestPart1(t *testing.T) {
	assert.Equal(t, 2, Part1(ReadLines("test.txt")))
	assert.Equal(t, 386, Part1(ReadLines("input.txt")))
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 3, Part2(ReadLines("test-2.txt")))
	assert.Equal(t, 208, Part2(ReadLines("input.txt")))
}
