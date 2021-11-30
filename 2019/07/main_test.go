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
		g := NewGame(tc.prog, 1)
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
	assert.Equal(t, 43210,
		part1([]int{3, 15, 3, 16, 1002, 16, 10, 16, 1, 16, 15,
			15, 4, 15, 99, 0, 0}))
	assert.Equal(t, 54321,
		part1([]int{3, 23, 3, 24, 1002, 24, 10, 24, 1002, 23, -1, 23,
			101, 5, 23, 23, 1, 24, 23, 23, 4, 23, 99, 0, 0}))
	assert.Equal(t, 65210,
		part1([]int{3, 31, 3, 32, 1002, 32, 10, 32, 1001, 31, -2, 31, 1007,
			31, 0, 33, 1002, 33, 7, 33, 1, 33, 31, 31, 1, 32, 31, 31, 4,
			31, 99, 0, 0, 0}))
	assert.Equal(t, 139629729,
		part2([]int{3, 26, 1001, 26, -4, 26, 3, 27, 1002, 27, 2, 27, 1, 27,
			26, 27, 4, 27, 1001, 28, -1, 28, 1005, 28, 6, 99, 0, 0, 5}))
	assert.Equal(t, 18216,
		part2([]int{3, 52, 1001, 52, -5, 52, 3, 53, 1, 52, 56, 54, 1007, 54,
			5, 55, 1005, 55, 26, 1001, 54, -5, 54, 1105, 1, 12, 1, 53, 54,
			53, 1008, 54, 0, 55, 1001, 55, 1, 55, 2, 53, 55, 53, 4, 53,
			1001, 56, -1, 56, 1005, 56, 6, 99, 0, 0, 0, 0, 10}))

	prog := aoc.SimpleReadInts(aoc.ReadLines("input.txt")[0])
	assert.Equal(t, 51679, part1(prog))
	assert.Equal(t, 19539216, part2(prog))
}
