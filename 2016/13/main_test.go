package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestPart1(t *testing.T) {
	game := Game{10, Point{7, 4}}
	assert.Equal(t, 11, game.Part1())
	game = Game{1358, Point{31, 39}}
	assert.Equal(t, 96, game.Part1())
}

func TestPart2(t *testing.T) {
	game := Game{10, Point{7, 4}}
	assert.Equal(t, 151, game.Part2())
	game = Game{1358, Point{31, 39}}
	assert.Equal(t, 141, game.Part2())
}
