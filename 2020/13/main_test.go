package main

import (
	"github.com/stretchr/testify/assert"
	"math/big"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

type TestCase1 struct {
	file string
	ans  int
}

func TestPart1(t *testing.T) {
	tests := []TestCase1{
		{"test1.txt", 295},
		{"test2.txt", 130},
		{"test3.txt", 295},
		{"test4.txt", 295},
		{"test5.txt", 295},
		{"test6.txt", 47},
		{"input.txt", 3035},
	}
	for _, tc := range tests {
		r := Part1(ReadLines(tc.file))
		assert.Equal(t, tc.ans, r)
	}
}

type TestCase2 struct {
	file string
	ans  *big.Int
}

func TestPart2(t *testing.T) {
	tests := []TestCase2{
		{"test1.txt", big.NewInt(1068781)},
		{"test2.txt", big.NewInt(3417)},
		{"test3.txt", big.NewInt(754018)},
		{"test4.txt", big.NewInt(779210)},
		{"test5.txt", big.NewInt(1261476)},
		{"test6.txt", big.NewInt(1202161486)},
		{"input.txt", big.NewInt(725169163285238)},
	}
	for _, tc := range tests {
		r := Part2(ReadLines(tc.file))
		assert.Equal(t, tc.ans, r)
	}
}
