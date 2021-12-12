package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestSolve(t *testing.T) {
	g := NewGame(ReadLines("test-0.txt"))
	sq, level := g.Solve()
	assert.Equal(t, "3,5,1", sq.String())
	assert.Equal(t, 4, level)

	g = NewGame(ReadLines("test-1.txt"))
	sq, level = g.Solve()
	assert.Equal(t, "122,79,1", sq.String())
	assert.Equal(t, -5, level)

	g = NewGame(ReadLines("test-2.txt"))
	sq, level = g.Solve()
	assert.Equal(t, "217,196,1", sq.String())
	assert.Equal(t, 0, level)

	g = NewGame(ReadLines("test-3.txt"))
	sq, level = g.Solve()
	assert.Equal(t, "101,153,1", sq.String())
	assert.Equal(t, 4, level)

	g = NewGame(ReadLines("test-4.txt"))
	sq, level = g.Solve()
	assert.Equal(t, "33,45,3", sq.String())
	assert.Equal(t, 29, level)

	g = NewGame(ReadLines("test-5.txt"))
	sq, level = g.Solve()
	assert.Equal(t, "21,61,3", sq.String())
	assert.Equal(t, 30, level)

	g = NewGame(ReadLines("test-6.txt"))
	sq, level = g.Solve()
	assert.Equal(t, "90,269,16", sq.String())
	assert.Equal(t, 113, level)

	g = NewGame(ReadLines("test-7.txt"))
	sq, level = g.Solve()
	assert.Equal(t, "232,251,12", sq.String())
	assert.Equal(t, 119, level)

	g = NewGame(ReadLines("test-8.txt"))
	sq, level = g.Solve()
	assert.Equal(t, "237,227,14", sq.String())
	assert.Equal(t, 108, level)

	g = NewGame(ReadLines("test-9.txt"))
	sq, level = g.Solve()
	assert.Equal(t, "237,227,14", sq.String())
	assert.Equal(t, 108, level)

	if !testing.Short() {
		g = NewGame(ReadLines("input.txt"))
		sq, level = g.Solve()
		assert.Equal(t, "237,227,14", sq.String())
		assert.Equal(t, 108, level)
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
