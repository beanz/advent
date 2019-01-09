package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent-of-code-go"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, 6, Part1(NewElfProg2018(ReadLines("test.txt"))))
	assert.Equal(t, 1764, Part1(NewElfProg2018(ReadLines("input.txt"))))
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 18992484, Part2(NewElfProg2018(ReadLines("input.txt"))))
}
