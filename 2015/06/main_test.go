package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent2015/lib"
)

type TestCase struct {
	in  string
	num int
}

func TestSwitch(t *testing.T) {
	tests := []TestCase{
		{"turn on 0,0 through 999,999", 1000000},
		{"toggle 0,0 through 999,0", 1000},
		{"turn off 499,499 through 500,500", 4},
	}
	for _, tc := range tests {
		c := 0
		sw(tc.in, func(a, b int, s string) { c++ })
		assert.Equal(t, tc.num, c, "switch: "+tc.in)
	}
}

func TestParts(t *testing.T) {
	in := ReadFileLines("input.txt")
	p1, p2 := calc(in)
	assert.Equal(t, 400410, p1)
	assert.Equal(t, 15343601, p2)
}
