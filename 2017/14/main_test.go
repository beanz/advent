package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestPart1(t *testing.T) {
	ones, _ := Part1("flqrgnkx")
	assert.Equal(t, 8108, ones)
	ones, _ = Part1("ugkiagan")
	assert.Equal(t, 8292, ones)
}

func TestPart2(t *testing.T) {
	_, m := Part1("flqrgnkx")
	assert.Equal(t, 1242, Part2(m))
	_, m = Part1("ugkiagan")
	assert.Equal(t, 1069, Part2(m))
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
