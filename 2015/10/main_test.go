package main

import (
	"fmt"
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestIter(t *testing.T) {
	tests := []string{"11", "21", "1211", "111221", "312211"}
	c := "1"
	for _, exp := range tests {
		n := Iter(c)
		assert.Equal(t, exp, n, "iter "+c+" => "+exp)
		c = exp
	}
}

type TestCase struct {
	s   string
	it  int
	len int
}

func TestRun(t *testing.T) {
	tests := []TestCase{
		{"1", 10, 26},
		{"1", 20, 408},
		{"1", 40, 82350},
		{"1", 50, 1166642},
		{ReadFileLines("input.txt")[0], 40, 360154},
		{ReadFileLines("input.txt")[0], 50, 5103798},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.len, len(Run(tc.s, tc.it)),
			fmt.Sprintf("part 1: %s %d", tc.s, tc.it))
	}
}
