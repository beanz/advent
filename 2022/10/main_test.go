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
	// Part 1: 15360
	// Part 2:
	// ###..#..#.#....#..#...##..##..####..##..
	// #..#.#..#.#....#..#....#.#..#....#.#..#.
	// #..#.####.#....####....#.#......#..#..#.
	// ###..#..#.#....#..#....#.#.##..#...####.
	// #....#..#.#....#..#.#..#.#..#.#....#..#.
	// #....#..#.####.#..#..##...###.####.#..#.
}

func TestParts(t *testing.T) {
	tests := []struct {
		file string
		data []byte
		p1   int
	}{
		{"test1.txt", test1, 13140},
		{"input.txt", input, 15360},
	}
	for _, tc := range tests {
		p1, _ := Parts(tc.data)
		assert.Equal(t, tc.p1, p1, tc.file)
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
