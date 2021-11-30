package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

type TestCase struct {
	prog  []int
	res   int
	valid bool
}

func TestPlay(t *testing.T) {
	tests := []TestCase{
		{[]int{1, 0, 0, 0, 99}, 2, true},
		{[]int{2, 3, 0, 3, 99}, 2, true},
		{[]int{2, 4, 4, 5, 99, 0}, 2, true},
		{[]int{1, 1, 1, 4, 99, 5, 6, 0, 99}, 30, true},
	}
	for _, tc := range tests {
		r, valid := NewGame(tc.prog).Part1()
		assert.Equal(t, tc.res, r)
		assert.Equal(t, tc.valid, valid)
	}
	prog := SimpleReadInts(ReadLines("input.txt")[0])
	prog[1] = 12
	prog[2] = 2
	r, _ := NewGame(prog).Part1()
	assert.Equal(t, 3409710, r)

	prog = SimpleReadInts(ReadLines("input.txt")[0])
	assert.Equal(t, 7912, NewGame(prog).Part2())
}
