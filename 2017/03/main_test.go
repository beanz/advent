package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, 0, Part1(1))
	assert.Equal(t, 3, Part1(12))
	assert.Equal(t, 2, Part1(23))
	assert.Equal(t, 31, Part1(1024))
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 54, Part2(26))
	assert.Equal(t, 806, Part2(747))
	assert.Equal(t, 2391, Part2(2380))
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
