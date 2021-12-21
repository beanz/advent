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
	// Part 1: 428736
	// Part 2: 57328067654557
}

func TestPart1(t *testing.T) {
	tests := []struct {
		file string
		data []byte
		ans  int
	}{
		{"test1.txt", test1, 739785},
		{"input.txt", input, 428736},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, NewGame(tc.data).Part1(), tc.file)
	}
}

func TestPart2(t *testing.T) {
	tests := []struct {
		file string
		data []byte
		ans  int64
	}{
		{"test1.txt", test1, 444356092776315},
		{"input.txt", input, 57328067654557},
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

func BenchmarkPart1(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		b.StopTimer()
		copy(input, safeinput)
		b.StartTimer()
		NewGame(input).Part1()
	}
}
