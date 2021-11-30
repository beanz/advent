package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

type TestCase struct {
	file string
	ans  int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test0.txt", 1},
		{"test1.txt", 1},
		{"test2.txt", 2},
		{"input.txt", 285},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, NewMatcher(ReadChunks(tc.file)).Part1())
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"input.txt", 412},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, NewMatcher(ReadChunks(tc.file)).Part2())
	}
}
