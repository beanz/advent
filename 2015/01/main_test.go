package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

type TestCase struct {
	in  string
	res int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"(())", 0},
		{"()()", 0},
		{"(((", 3},
		{"(()(()(", 3},
		{"))(((((", 3},
		{"())", -1},
		{"))(", -1},
		{")))", -3},
		{")())())", -3},
	}
	for _, tc := range tests {
		p1, _ := calc([]byte(tc.in))
		assert.Equal(t, tc.res, p1, tc.in)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{")", 1},
		{"()())", 5},
	}
	for _, tc := range tests {
		_, p2 := calc([]byte(tc.in))
		assert.Equal(t, tc.res, p2, tc.in)
	}
}

func TestInput(t *testing.T) {
	p1, p2 := calc(ReadFileBytes("input.txt"))
	assert.Equal(t, 138, p1, "Part 1 on input.txt")
	assert.Equal(t, 1771, p2, "Part 2 on input.txt")
}
