package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent-of-code-go"
)

type TestCase struct {
	file  string
	steps int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test1a.txt", 23},
		{"test1b.txt", 58},
		{"input.txt", 482},
	}
	for _, tc := range tests {
		r := NewDonut(ReadLines(tc.file)).Part1()
		assert.Equal(t, tc.steps, r)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test1a.txt", 26},
		{"test2a.txt", 396},
		{"input.txt", 5912},
	}
	for _, tc := range tests {
		r := NewDonut(ReadLines(tc.file)).Part2()
		assert.Equal(t, tc.steps, r)
	}

}
