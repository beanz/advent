package main

import (
	aoc "github.com/beanz/advent/lib-go"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestArity(t *testing.T) {
	assert.Equal(t, 0, OpArity(99))
	assert.Equal(t, 3, OpArity(1))
	assert.Equal(t, 3, OpArity(2))
	assert.Equal(t, 1, OpArity(3))
	assert.Equal(t, 1, OpArity(4))
	assert.Equal(t, 2, OpArity(5))
	assert.Equal(t, 2, OpArity(6))
	assert.Equal(t, 3, OpArity(7))
	assert.Equal(t, 3, OpArity(8))
}

type ParseInstTestCase struct {
	prog  []int
	op    int
	param []int
	addr  []int
	ip    int
}

func TestParseInst(t *testing.T) {
	tests := []ParseInstTestCase{
		{[]int{1, 0, 0, 3, 99}, 1, []int{1, 1, 3}, []int{0, 0, 3}, 4},
		{[]int{2, 3, 0, 3, 99}, 2, []int{3, 2, 3}, []int{3, 0, 3}, 4},
		{[]int{1002, 4, 3, 4, 33}, 2, []int{33, 3, 33}, []int{4, -99, 4}, 4},
	}
	for _, tc := range tests {
		g := NewGame(tc.prog)
		inst, _ := g.ParseInst()
		assert.Equal(t, tc.op, inst.op)
		assert.Equal(t, tc.param, inst.param)
		assert.Equal(t, tc.addr, inst.addr)
		assert.Equal(t, tc.ip, g.ip)
	}
}

type TestCase struct {
	prog []int
	in   int
	out  int
}

func TestPlay(t *testing.T) {
	tests := []TestCase{
		{[]int{3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8}, 8, 1},
		{[]int{3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8}, 4, 0},
		{[]int{3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8}, 7, 1},
		{[]int{3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8}, 8, 0},
		{[]int{3, 3, 1108, -1, 8, 3, 4, 3, 99}, 8, 1},
		{[]int{3, 3, 1108, -1, 8, 3, 4, 3, 99}, 9, 0},
		{[]int{3, 3, 1107, -1, 8, 3, 4, 3, 99}, 7, 1},
		{[]int{3, 3, 1107, -1, 8, 3, 4, 3, 99}, 9, 0},
		{[]int{3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9}, 2, 1},
		{[]int{3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9}, 0, 0},
		{[]int{3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1}, 3, 1},
		{[]int{3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1}, 0, 0},
		{[]int{3, 21, 1008, 21, 8, 20, 1005, 20, 22, 107, 8, 21, 20, 1006,
			20, 31, 1106, 0, 36, 98, 0, 0, 1002, 21, 125, 20, 4, 20, 1105,
			1, 46, 104, 999, 1105, 1, 46, 1101, 1000, 1, 20, 4, 20, 1105,
			1, 46, 98, 99}, 5, 999},
		{[]int{3, 21, 1008, 21, 8, 20, 1005, 20, 22, 107, 8, 21, 20, 1006,
			20, 31, 1106, 0, 36, 98, 0, 0, 1002, 21, 125, 20, 4, 20, 1105,
			1, 46, 104, 999, 1105, 1, 46, 1101, 1000, 1, 20, 4, 20, 1105,
			1, 46, 98, 99}, 8, 1000},
		{[]int{3, 21, 1008, 21, 8, 20, 1005, 20, 22, 107, 8, 21, 20, 1006,
			20, 31, 1106, 0, 36, 98, 0, 0, 1002, 21, 125, 20, 4, 20, 1105,
			1, 46, 104, 999, 1105, 1, 46, 1101, 1000, 1, 20, 4, 20, 1105,
			1, 46, 98, 99}, 9, 1001},
	}
	for _, tc := range tests {
		g := NewGame(tc.prog)
		g.Run(tc.in)
		assert.Equal(t, tc.out, g.out[0])
	}
	prog := aoc.SimpleReadInts(aoc.ReadLines("input.txt")[0])
	assert.Equal(t, 16209841, NewGame(prog).Part1())
	prog = aoc.SimpleReadInts(aoc.ReadLines("input.txt")[0])
	assert.Equal(t, 8834787, NewGame(prog).Part2())
}
