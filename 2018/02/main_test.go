package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, 12, Part1(ReadLines("test-1.txt")))
	assert.Equal(t, 9633, Part1(ReadLines("input.txt")))
}

func TestPart2(t *testing.T) {
	assert.Equal(t, "fgij", Part2(ReadLines("test-2.txt")))
	assert.Equal(t, "lujnogabetpmsydyfcovzixaw", Part2(ReadLines("input.txt")))
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
