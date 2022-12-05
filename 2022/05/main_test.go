package main

import (
	_ "embed"
	"testing"

	assert "github.com/stretchr/testify/require"
)

//go:embed test1.txt
var test1 []byte

//go:embed input.txt
var safeinput []byte

func ExampleMain() {
	main()
	//Output:
	// Part 1: PTWLTDSJV
	// Part 2: WZMFVGGZP
}

func TestPart1(t *testing.T) {
	tests := []struct {
		file string
		data []byte
		ans  string
	}{
		{"test1.txt", test1, "CMZ"},
		{"input.txt", input, "PTWLTDSJV"},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, NewGame(tc.data).Part1(), tc.file)
	}
}

func TestPart2(t *testing.T) {
	tests := []struct {
		file string
		data []byte
		ans  string
	}{
		{"test1.txt", test1, "MCD"},
		{"input.txt", input, "WZMFVGGZP"},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, NewGame(tc.data).Part2(), tc.file)
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
