package main

import (
	"fmt"
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent2015/lib"
)

type TestCase struct {
	file string
	tar  int
	exp  int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 25, 4},
		{"input.txt", 150, 1304},
	}
	for _, tc := range tests {
		n, _ := calc(ReadFileInts(tc.file), tc.tar)
		assert.Equal(t, tc.exp, n,
			fmt.Sprintf("part 1: %s %d", tc.file, tc.tar))
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 25, 3},
		{"input.txt", 150, 18},
	}
	for _, tc := range tests {
		_, n := calc(ReadFileInts(tc.file), tc.tar)
		assert.Equal(t, tc.exp, n,
			fmt.Sprintf("part 2: %s %d", tc.file, tc.tar))
	}
}
