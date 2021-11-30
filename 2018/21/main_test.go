package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, 12446070, Part1(NewElfProg2018(ReadLines("input.txt"))))
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 13928239, Part2(nil))
	//assert.Equal(t, 13928239, Part2Slow(NewElfProg2018(ReadLines("input.txt"))))
}
