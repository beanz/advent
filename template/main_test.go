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

func ExampleMain() {
	main()
	//Output:
	// Part 1: 1
	// Part 2: 2
}

func TestPart1(t *testing.T) {
	tests := []struct {
		file string
		data []byte
		ans  int
	}{
		{"test1.txt", test1, 1},
		{"input.txt", input, 2},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, NewGame(tc.data).Part1(), tc.file)
	}
}

func TestPart2(t *testing.T) {
	tests := []struct {
		file string
		data []byte
		ans  int
	}{
		{"test1.txt", test1, 2},
		{"input.txt", input, 4},
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
