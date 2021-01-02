package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

type TestCase struct {
	file string
	exp  int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 330},
		{"input.txt", 664},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.exp, NewTable(ReadFileLines(tc.file)).Part1(),
			"part 1: "+tc.file)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 286},
		{"input.txt", 640},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.exp, NewTable(ReadFileLines(tc.file)).Part2(),
			"part 2: "+tc.file)
	}
}
