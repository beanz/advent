package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent-of-code-go"
)

type TestCase struct {
	file   string
	phases int
	res    string
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test1a.txt", 4, "01029498"},
		{"test1b.txt", 100, "24176176"},
		{"test1c.txt", 100, "73745418"},
		{"test1d.txt", 100, "52432133"},
		{"input.txt", 100, "23135243"},
	}
	for _, tc := range tests {
		r := Part1(ReadUint8s(ReadLines(tc.file)[0]), tc.phases)
		assert.Equal(t, tc.res, r)
	}

}

type TestCase2 struct {
	file string
	res  string
}

func TestPart2(t *testing.T) {
	tests := []TestCase2{
		{"test2a.txt", "84462026"},
		{"test2b.txt", "78725270"},
		{"test2c.txt", "53553731"},
		{"input.txt", "21130597"},
	}
	for _, tc := range tests {
		r := Part2(ReadUint8s(ReadLines(tc.file)[0]))
		assert.Equal(t, tc.res, r)
	}

}
