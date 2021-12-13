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
		{"test1.txt", test1, "easter"},
		{"input.txt", input, "ursvoerv"},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, NewComms(tc.data).Part1(), tc.file)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", test1, "advent"},
		{"input.txt", input, "vomaypnn"},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, NewComms(tc.data).Part2(), tc.file)
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
