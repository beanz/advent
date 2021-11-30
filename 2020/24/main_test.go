package main

import (
	"fmt"
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

type TestCase1 struct {
	file string
	ans  int
}

func TestPart1(t *testing.T) {
	tests := []TestCase1{
		{"test1.txt", 10},
		{"input.txt", 307},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, NewGame(ReadLines(tc.file)).Part1(), tc.file)
	}
}

type TestCase2 struct {
	file string
	days int
	ans  int
}

func TestPart2(t *testing.T) {
	tests := []TestCase2{
		{"test1.txt", 1, 15},
		{"test1.txt", 2, 12},
		{"test1.txt", 10, 37},
		{"test1.txt", 100, 2208},
		{"input.txt", 100, 3787},
	}
	for _, tc := range tests {
		assert.Equal(t,
			tc.ans, NewGame(ReadLines(tc.file)).Part2(tc.days),
			fmt.Sprintf("%s x %d", tc.file, tc.days))
	}
}
