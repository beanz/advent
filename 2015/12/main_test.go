package main

import (
	"testing"

	"github.com/stretchr/testify/assert"

	. "github.com/beanz/advent/lib-go"
)

type TestCase struct {
	in  string
	res int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"[1,2,3]", 6},
		{"{\"a\":2,\"b\":4}", 6},
		{"[[[3]]]", 3},
		{"{\"a\":{\"b\":4},\"c\":-1}", 3},
		{"{\"a\":[-1,1]}", 0},
		{"[-1,{\"a\":1}]", 0},
		{"[]", 0},
		{"{}", 0},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.res, Part1([]byte(tc.in)), tc.in)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"[1,2,3]", 6},
		{"[1,{\"c\":\"red\",\"b\":2},3]", 4},
		{"{\"d\":\"red\",\"e\":[1,2,3,4],\"f\":5}", 0},
		{"[1,\"red\",5]", 6},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.res, Part2(tc.in), tc.in)
	}
}

func TestInput(t *testing.T) {
	assert.Equal(t, 119433, Part1(input), "Part 1 on input.txt")
	in := ReadFileLines("input.txt")[0]
	assert.Equal(t, 68466, Part2(in), "Part 2 on input.txt")
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
