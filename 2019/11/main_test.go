package main

import (
	. "github.com/beanz/advent-of-code-go"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestPlay(t *testing.T) {
	prog := SimpleReadInts(ReadLines("input.txt")[0])
	assert.Equal(t, 2141, part1(prog))
	assert.Equal(t, (".###..###....##..##..####.####.#..#.####...\n" +
		".#..#.#..#....#.#..#.#.......#.#.#..#......\n" +
		".#..#.#..#....#.#....###....#..##...###....\n" +
		".###..###.....#.#....#.....#...#.#..#......\n" +
		".#.#..#....#..#.#..#.#....#....#.#..#......\n" +
		".#..#.#.....##...##..#....####.#..#.#......\n"),
		part2(prog))
}
