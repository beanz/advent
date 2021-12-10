package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestPlay(t *testing.T) {
	assert.Equal(t, 3, NewGame(ReadChunks("test.txt")).Part1())
	assert.Equal(t, 4217, NewGame(ReadChunks("input.txt")).Part1())
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
