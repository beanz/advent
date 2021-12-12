package main

import (
	_ "embed"
	"github.com/stretchr/testify/assert"
	"testing"
)

//go:embed test1.txt
var test1 []byte

//go:embed test2.txt
var test2 []byte

//go:embed test3.txt
var test3 []byte

//go:embed input.txt
var safeinput []byte

type TestCase struct {
	file string
	data []byte
	ans  int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", test1, 10},
		{"test2.txt", test2, 19},
		{"test3.txt", test3, 226},
		{"input.txt", input, 4691},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, NewCave(tc.data).Part1(), tc.file)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", test1, 36},
		{"test2.txt", test2, 103},
		{"test3.txt", test3, 3509},
		{"input.txt", input, 140718},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, NewCave(tc.data).Part2(), tc.file)
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		b.StopTimer()
		copy(input, safeinput)
		b.StartTimer()
		main()
	}
}
