package main

import (
	"github.com/stretchr/testify/assert"
	"strings"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

type TestCase struct {
	prog  []int
	res   int
	valid bool
}

func TestPlay(t *testing.T) {

	assert.Equal(t, 42,
		NewGame(strings.Split("COM)B B)C C)D D)E E)F B)G G)H D)I E)J J)K K)L",
			" ")).Part1())
	assert.Equal(t, 4,
		NewGame(strings.Split("COM)B B)C C)D D)E E)F B)G G)H D)I E)J J)K K)L K)YOU I)SAN",
			" ")).Part2())

	assert.Equal(t, 122782, NewGame(ReadLines("input.txt")).Part1())
	assert.Equal(t, 271, NewGame(ReadLines("input.txt")).Part2())
}
