package main

import (
	aoc "github.com/beanz/advent/lib-go"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestPlay(t *testing.T) {
	prog := aoc.SimpleReadInt64s(aoc.ReadLines("input.txt")[0])
	assert.Equal(t, 2141, part1(prog))
	assert.Equal(t, (".###..###....##..##..####.####.#..#.####...\n" +
		".#..#.#..#....#.#..#.#.......#.#.#..#......\n" +
		".#..#.#..#....#.#....###....#..##...###....\n" +
		".###..###.....#.#....#.....#...#.#..#......\n" +
		".#.#..#....#..#.#..#.#....#....#.#..#......\n" +
		".#..#.#.....##...##..#....####.#..#.#......\n"),
		part2(prog))
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
