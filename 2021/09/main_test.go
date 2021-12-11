package main

import (
	_ "embed"
	"fmt"
	"github.com/stretchr/testify/assert"
	"testing"
)

//go:embed test1.txt
var test1 []byte

//go:embed input.txt
var safeinput []byte

type TestCase struct {
	file string
	data []byte
	ans  int
}

func TestPart1(t *testing.T) {
	if string(input[:10]) != "5456898789" {
		copy(input, safeinput)
	}
	tests := []TestCase{
		{"test1.txt", test1, 15},
		{"input.txt", input, 456},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, NewLavaTubes(tc.data).Part1(), tc.file)
	}
}

func TestPart2(t *testing.T) {
	if string(input[:10]) != "5456898789" {
		copy(input, safeinput)
	}
	tests := []TestCase{
		{"test1.txt", test1, 1134},
		{"input.txt", input, 1047744},
	}
	for _, tc := range tests {
		lt := NewLavaTubes(tc.data)
		lt.Part1()
		assert.Equal(t, tc.ans, lt.Part2(), tc.file)
	}
}

func TestByteMapContains(t *testing.T) {
	tests := []struct {
		x, y int
		exp  bool
	}{
		{x: 0, y: 0, exp: true},
		{x: -1, y: 0, exp: false},
		{x: 9, y: 0, exp: true},
		{x: 10, y: 0, exp: false},
		{x: 0, y: -1, exp: false},
		{x: 0, y: 4, exp: true},
		{x: 0, y: 5, exp: false},
	}
	lt := NewByteMap(test1)
	for _, tc := range tests {
		assert.Equal(t, tc.exp,
			lt.Contains(tc.x+tc.y*lt.w), fmt.Sprintf("%d,%d", tc.x, tc.y))
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
