package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestParseGroup1(t *testing.T) {
}

func TestPlay1(t *testing.T) {
	s := "abc"
	game := readGame(s)
	assert.Equal(t, "abc", game.doorID, "Door ID should be set")
	assert.Equal(t, "18f47a30", game.Part1(),
		"Next password should be calculated")
}

func TestPlay2(t *testing.T) {
	s := "abc"
	game := readGame(s)
	assert.Equal(t, "abc", game.doorID, "Door ID should be set")
	assert.Equal(t, "05ace8e3", game.Part2(),
		"Next password should be calculated")
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
