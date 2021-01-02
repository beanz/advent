package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

type TestCase struct {
	file string
	ch   string
	num  int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", "d", 72},
		{"test1.txt", "e", 507},
		{"test1.txt", "f", 492},
		{"test1.txt", "g", 114},
		{"test1.txt", "h", 65412},
		{"test1.txt", "i", 65079},
		{"test1.txt", "x", 123},
		{"test1.txt", "y", 456},
		{"input.txt", "a", 956},
	}
	for _, tc := range tests {
		in := ReadFileLines(tc.file)
		assert.Equal(t, tc.num, Part1(in, tc.ch),
			"part 1: "+tc.file+" "+tc.ch)
	}
	assert.Equal(t, 40149, Part2(ReadFileLines("input.txt"), "a", 956),
		"part 2: input.txt a 956")
}
