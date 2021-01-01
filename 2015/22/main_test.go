package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent2015/lib"
)

func TestParts(t *testing.T) {
	g := NewGame(ReadFileInts("input.txt"))
	p1, p2 := g.Calc()
	assert.Equal(t, 1824, p1, "part 1")
	assert.Equal(t, 1937, p2, "part 2")
}
