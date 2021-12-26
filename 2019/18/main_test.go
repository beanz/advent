package main

import (
	_ "embed"
	assert "github.com/stretchr/testify/require"
	"testing"
)

//go:embed test1a.txt
var test1a []byte

//go:embed test1b.txt
var test1b []byte

//go:embed test1c.txt
var test1c []byte

//go:embed test1d.txt
var test1d []byte

//go:embed test1e.txt
var test1e []byte

//go:embed test2a.txt
var test2a []byte

//go:embed test2b.txt
var test2b []byte

//go:embed test2c.txt
var test2c []byte

//go:embed test2d.txt
var test2d []byte

func ExampleMain() {
	main()
	//Output:
	// Part 1: 4406
	// Part 2: 1964
}

func TestPart1(t *testing.T) {
	tests := []struct {
		file string
		data []byte
		ans  int
	}{
		{"test1a.txt", test1a, 8},
		{"test1b.txt", test1b, 86},
		{"test1c.txt", test1c, 132},
		{"test1d.txt", test1d, 136},
		{"test1e.txt", test1e, 81},
		{"test2a.txt", test2a, 26},
		{"test2b.txt", test2b, 50},
		{"test2c.txt", test2c, 127},
		{"test2d.txt", test2d, 114},
	}
	for _, tc := range tests {
		data := make([]byte, len(tc.data))
		copy(data, tc.data)
		v := NewVault(data)
		v.Optimaze()
		p1 := v.Part1()
		assert.Equal(t, tc.ans, p1, tc.file)
	}
}

func TestPart2(t *testing.T) {
	tests := []struct {
		file string
		data []byte
		ans  int
	}{
		{"test2a.txt", test2a, 8},
		{"test2b.txt", test2b, 24},
		{"test2c.txt", test2c, 32},
		// TOFIX? {"test2d.txt", test2d, 72},
	}
	for _, tc := range tests {
		data := make([]byte, len(tc.data))
		copy(data, tc.data)
		v := NewVault(data)
		v.Optimaze()
		p2 := v.Part2()
		assert.Equal(t, tc.ans, p2, tc.file)
	}
}

//go:embed input.txt
var safeinput []byte

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		b.StopTimer()
		copy(input, safeinput)
		b.StartTimer()
		main()
	}
}
