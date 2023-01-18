package main

import (
	"testing"

	"github.com/stretchr/testify/assert"

	_ "embed"
)

//go:embed test.txt
var test []byte

func TestPart1(t *testing.T) {
	assert.Equal(t, 138, NewGame(test).Part1())
	assert.Equal(t, 42798, NewGame(input).Part1())
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 66, NewGame(test).Part2())
	assert.Equal(t, 23798, NewGame(input).Part2())
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
