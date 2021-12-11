package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	aoc "github.com/beanz/advent/lib-go"
)

func TestRun(t *testing.T) {
	g := NewComp([]string{"inc a", "jio a, +2", "tpl a", "inc a"})
	g.Run()
	assert.Equal(t, uint(2), g.reg[RA], "simple set reg a to 2")
}

func TestParts(t *testing.T) {
	g := NewComp(aoc.ReadFileLines("input.txt"))
	assert.Equal(t, uint(255), g.Part1(), "part 1")
	assert.Equal(t, uint(334), g.Part2(), "part 2")
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
