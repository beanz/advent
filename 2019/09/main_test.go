package main

import (
	"fmt"
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
	assert.Equal(t, 1, OpArity(9))
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
	assert.Equal(t,
		"109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99",
		part1([]int{109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16,
			101, 1006, 101, 0, 99}))
	assert.Equal(t, fmt.Sprintf("%d", 34915192*34915192),
		part1([]int{1102, 34915192, 34915192, 7, 4, 7, 99, 0}))
	assert.Equal(t, "1125899906842624",
		part1([]int{104, 1125899906842624, 99}))

	prog := aoc.SimpleReadInts(aoc.ReadLines("input.txt")[0])
	assert.Equal(t, "3100786347", part1(prog))
	assert.Equal(t, "87023", part2(prog))
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
