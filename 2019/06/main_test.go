package main

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"

	. "github.com/beanz/advent/lib-go"
)

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

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
