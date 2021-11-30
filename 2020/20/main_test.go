package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestTile(t *testing.T) {
	ts := "Tile 33:\n.#.\n.##\n#.#"
	tile := NewTile(ts)
	assert.Equal(t, uint64(33), tile.Num())
	assert.Equal(t, []string{".#.", ".##", "#.#"}, tile.Lines())
	assert.Equal(t, ".#.", tile.Top())
	assert.Equal(t, ".##", tile.Right())
	assert.Equal(t, "#.#", tile.Bottom())
	assert.Equal(t, "..#", tile.Left())
	flip := tile.Flip()
	assert.Equal(t, uint64(33), flip.Num())
	assert.Equal(t, []string{"#.#", ".##", ".#."}, flip.Lines())
	assert.Equal(t, "#.#", flip.Top())
	assert.Equal(t, "##.", flip.Right())
	assert.Equal(t, ".#.", flip.Bottom())
	assert.Equal(t, "#..", flip.Left())
	r1 := tile.Rotate()
	assert.Equal(t, uint64(33), r1.Num())
	assert.Equal(t, []string{"#..", ".##", "##."}, r1.Lines())
	assert.Equal(t, "#..", r1.Top())
	assert.Equal(t, ".#.", r1.Right())
	assert.Equal(t, "##.", r1.Bottom())
	assert.Equal(t, "#.#", r1.Left())
	r2 := r1.Rotate()
	assert.Equal(t, uint64(33), r2.Num())
	assert.Equal(t, []string{"#.#", "##.", ".#."}, r2.Lines())
	assert.Equal(t, "#.#", r2.Top())
	assert.Equal(t, "#..", r2.Right())
	assert.Equal(t, ".#.", r2.Bottom())
	assert.Equal(t, "##.", r2.Left())
	r3 := r2.Rotate()
	assert.Equal(t, uint64(33), r3.Num())
	assert.Equal(t, []string{".##", "##.", "..#"}, r3.Lines())
	assert.Equal(t, ".##", r3.Top())
	assert.Equal(t, "#.#", r3.Right())
	assert.Equal(t, "..#", r3.Bottom())
	assert.Equal(t, ".#.", r3.Left())
}

type TestCase1 struct {
	file string
	ans  uint64
}

func TestPart1(t *testing.T) {
	tests := []TestCase1{
		{"test1.txt", 20899048083289},
		{"input.txt", 17712468069479},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, NewWater(ReadChunks(tc.file)).Part1(), tc.file)
	}
}

type TestCase2 struct {
	file string
	ans  int
}

func TestPart2(t *testing.T) {
	tests := []TestCase2{
		{"test1.txt", 273},
		{"input.txt", 2173},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, NewWater(ReadChunks(tc.file)).Part2(), tc.file)
	}
}
