package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestPlay(t *testing.T) {
	best, longest := NewGame(ReadLines("test.txt")).Play()
	assert.Equal(t, 31, best)
	assert.Equal(t, 19, longest)
	best, longest = NewGame(ReadLines("input.txt")).Play()
	assert.Equal(t, 1940, best)
	assert.Equal(t, 1928, longest)
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
