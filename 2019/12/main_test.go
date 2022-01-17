package main

import (
    _ "embed"
	"github.com/stretchr/testify/assert"
	"testing"
)

//go:embed test1a.txt
var test1a []byte
//go:embed test1b.txt
var test1b []byte
//go:embed test2.txt
var test2 []byte

type TestCase1 struct {
	file  string
    data  []byte
	steps int
	res   int
}

func TestPart1(t *testing.T) {
	tests := []TestCase1{
		{"test1a.txt", test1a, 10, 179},
		{"test1b.txt", test1b, 100, 1940},
		{"input.txt", input, 1000, 8044},
	}
	for _, tc := range tests {
		res := NewMoons(tc.data).Part1(tc.steps)
		assert.Equal(t, tc.res, res)
	}
}

type TestCase2 struct {
	file string
    data []byte
	res  int64
}

func TestPart2(t *testing.T) {
	tests := []TestCase2{
		{"test1a.txt", test1a, 2772},
		{"test2.txt", test2, 4686774924},
		{"input.txt", input, 362375881472136},
	}
	for _, tc := range tests {
		res := NewMoons(tc.data).Part2()
		assert.Equal(t, tc.res, res)
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
