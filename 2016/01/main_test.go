package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestLeftRight(t *testing.T) {
	d := Dir{0, -1}
	d.L()
	assert.Equal(t, -1, d[0], "left from north is west")
	assert.Equal(t, 0, d[1], "left from north is west")
	d.L()
	assert.Equal(t, 0, d[0], "left from west is south")
	assert.Equal(t, 1, d[1], "left from west is south")
	d.L()
	assert.Equal(t, 1, d[0], "left from south is east")
	assert.Equal(t, 0, d[1], "left from south is east")
	d.L()
	assert.Equal(t, 0, d[0], "left from east is north")
	assert.Equal(t, -1, d[1], "left from east is north")

	d.R()
	assert.Equal(t, 1, d[0], "right from north is east")
	assert.Equal(t, 0, d[1], "right from north is east")
	d.R()
	assert.Equal(t, 0, d[0], "right from east is south")
	assert.Equal(t, 1, d[1], "right from east is south")
	d.R()
	assert.Equal(t, -1, d[0], "right from south is west")
	assert.Equal(t, 0, d[1], "right from south is west")
	d.R()
	assert.Equal(t, 0, d[0], "right from west is north")
	assert.Equal(t, -1, d[1], "right from west is north")
}

type TestCase struct {
	in  string
	exp int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"R2, L3", 5},
		{"R2, R2, R2", 2},
		{"R5, L5, R5, R3", 12},
	}
	for _, tc := range tests {
		p1, _ := Calc(tc.in)
		assert.Equal(t, tc.exp, p1, "part 1: "+tc.in)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"R8, R4, R4, R8", 4},
	}
	for _, tc := range tests {
		_, p2 := Calc(tc.in)
		assert.Equal(t, tc.exp, p2, "part 2: "+tc.in)
	}
}

func TestParts(t *testing.T) {
	p1, p2 := Calc(ReadFileLines("input.txt")[0])
	assert.Equal(t, 231, p1, "part 1 with input.txt")
	assert.Equal(t, 147, p2, "part 2 with input.txt")
}
