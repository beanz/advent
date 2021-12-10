package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, 3, Part1(ReadInput("test.txt")))
	assert.Equal(t, 505, Part1(ReadInput("input.txt")))
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 2, Part2(ReadInput("test.txt")))
	assert.Equal(t, 72330, Part2(ReadInput("input.txt")))
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
