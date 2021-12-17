package main

import (
	_ "embed"
	. "github.com/beanz/advent/lib-go"
	"github.com/stretchr/testify/assert"
	"testing"
)

func ExampleMain() {
	main()
	//Output:
	// Part 1: 123
	// Part 2:
	//
	// .##..####.###..#..#.###..####.###....##.###...###.
	// #..#.#....#..#.#..#.#..#....#.#..#....#.#..#.#....
	// #..#.###..###..#..#.#..#...#..###.....#.#..#.#....
	// ####.#....#..#.#..#.###...#...#..#....#.###...##..
	// #..#.#....#..#.#..#.#....#....#..#.#..#.#.......#.
	// #..#.#....###...##..#....####.###...##..#....###..
}

//go:embed test.txt
var test1 []byte

func TestDisp(t *testing.T) {
	disp := NewDisp(7, 3)
	disp.Run(InputBytes(test1))
	assert.Equal(t, 6, disp.Count(), "pixel count")
	assert.Equal(t, ".#..#.#\n#.#....\n.#.....\n", disp.String(), "display")
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
