package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestPart1(t *testing.T) {
	g := readGame([]string{"5-8", "0-2", "4-7"})
	assert.Equal(t, int64(3), g.Part1())
	g = readGame([]string{"5-8", "0-3", "4-7"})
	assert.Equal(t, int64(9), g.Part1())
}

func TestPart2(t *testing.T) {
	g := readGame([]string{"5-8", "0-2", "4-7"})
	assert.Equal(t, int64(2), g.Part2(9))
	g = readGame([]string{"5-8", "0-3", "4-7"})
	assert.Equal(t, int64(1), g.Part2(9))
	g = readGame([]string{"5-8", "2-3", "0-7"})
	assert.Equal(t, int64(1), g.Part2(9))
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
