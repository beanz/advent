package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

type TestCase1 struct {
	file  string
	steps int
	res   int
}

func TestPart1(t *testing.T) {
	tests := []TestCase1{
		{"test1a.txt", 10, 179},
		{"test1b.txt", 100, 1940},
		{"input.txt", 1000, 8044},
	}
	for _, tc := range tests {
		res := NewMoons(ReadLines(tc.file)).Part1(tc.steps)
		assert.Equal(t, tc.res, res)
	}
}

type TestCase2 struct {
	file string
	res  int64
}

func TestPart2(t *testing.T) {
	tests := []TestCase2{
		{"test1a.txt", 2772},
		{"test2.txt", 4686774924},
		{"input.txt", 362375881472136},
	}
	for _, tc := range tests {
		res := NewMoons(ReadLines(tc.file)).Part2()
		assert.Equal(t, tc.res, res)
	}
}
