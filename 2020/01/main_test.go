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
		{"test1.txt", 514579},
		{"input.txt", 41979},
	}
	for _, tc := range tests {
		r := NewReport(ReadLines(tc.file)).Part1()
		assert.Equal(t, tc.ans, r)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 241861950},
		{"input.txt", 193416912},
	}
	for _, tc := range tests {
		r := NewReport(ReadLines(tc.file)).Part2()
		assert.Equal(t, tc.ans, r)
	}
}
