package main

import (
	_ "embed"
	assert "github.com/stretchr/testify/require"
	"testing"
)

//go:embed test1.txt
var test1 []byte

//go:embed input.txt
var safeinput []byte

type TestCase struct {
	file string
	data []byte
	ans  string
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", test1, "1985"},
		{"input.txt", input, "52981"},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, Decode(tc.data, PadOne()), tc.file)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", test1, "5DB3"},
		{"input.txt", input, "74CD2"},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, Decode(tc.data, PadTwo()), tc.file)
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
