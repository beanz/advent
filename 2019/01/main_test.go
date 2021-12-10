package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestPlay(t *testing.T) {
	assert.Equal(t, 2, NewGame([]int{12}).Part1())
	assert.Equal(t, 2, NewGame([]int{14}).Part1())
	assert.Equal(t, 654, NewGame([]int{1969}).Part1())
	assert.Equal(t, 33583, NewGame([]int{100756}).Part1())
	assert.Equal(t, 34241, NewGame([]int{12, 14, 1969, 100756}).Part1())
	mass := ReadInts(ReadLines("input.txt"))
	assert.Equal(t, 3363033, NewGame(mass).Part1())

	assert.Equal(t, 2, NewGame([]int{14}).Part2())
	assert.Equal(t, 966, NewGame([]int{1969}).Part2())
	assert.Equal(t, 50346, NewGame([]int{100756}).Part2())
	assert.Equal(t, 51316, NewGame([]int{12, 14, 1969, 100756}).Part2())
	assert.Equal(t, 5041680, NewGame(mass).Part2())
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
