package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, 638, NewGame(3).Part1(2017))
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 1222153, NewGame(3).Part2())
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
