package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, 99, Part1(ReadFileInts("test1.txt")))
	assert.Equal(t, 11266889531, Part1(ReadFileInts("input.txt")))
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 44, Part2(ReadFileInts("test1.txt")))
	assert.Equal(t, 77387711, Part2(ReadFileInts("input.txt")))
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
