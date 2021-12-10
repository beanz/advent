package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
	. "github.com/beanz/advent/lib-go"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, 1, (&Stream{"{},", 0, 1, false}).Part1())
	assert.Equal(t, 6, (&Stream{"{{{}}},", 0, 1, false}).Part1())
	assert.Equal(t, 16, (&Stream{"{{{},{},{{}}}},", 0, 1, false}).Part1())
	assert.Equal(t, 1, (&Stream{"{<a>,<a>,<a>,<a>},", 0, 1, false}).Part1())
	assert.Equal(t,
		9, (&Stream{"{{<ab>},{<ab>},{<ab>},{<ab>}},", 0, 1, false}).Part1())
	assert.Equal(t,
		9, (&Stream{"{{<!!>},{<!!>},{<!!>},{<!!>}},", 0, 1, false}).Part1())
	assert.Equal(t,
		3, (&Stream{"{{<a!>},{<a!>},{<a!>},{<ab>}},", 0, 1, false}).Part1())
	assert.Equal(t, 16869, NewStream(InputLines(input)).Part1())
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 7284, NewStream(InputLines(input)).Part2())
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
