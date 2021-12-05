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
		{"test1.txt", 10},
		{"input.txt", 307},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, NewGame(ReadLines(tc.file)).Part1(), tc.file)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 10},
		{"input.txt", 307},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, NewGame(ReadLines(tc.file)).Part2(), tc.file)
	}
}
