package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

type TestCase struct {
	file  string
	part1 int
	best  Point
}

func TestVisible(t *testing.T) {
	g := NewGame([]string{
		".#..#",
		".....",
		"#####",
		"....#",
		"...##"})
	assert.Equal(t, false, g.visible(Point{3, 4}, Point{1, 0}))
	assert.Equal(t, false, g.visible(Point{4, 4}, Point{4, 2}))
	assert.Equal(t, true, g.visible(Point{3, 4}, Point{2, 2}))
	assert.Equal(t, true, g.visible(Point{3, 4}, Point{4, 0}))
	assert.Equal(t, false, g.visible(Point{4, 4}, Point{4, 0}))
	assert.Equal(t, true, g.visible(Point{4, 4}, Point{4, 3}))
}

func TestAngle(t *testing.T) {
	assert.Equal(t, 0.0, angle(Point{2, 2}, Point{2, 0}))                // n
	assert.Equal(t, 0.7853981633974483, angle(Point{2, 2}, Point{4, 0})) // ne
	assert.Equal(t, 1.5707963267948966, angle(Point{2, 2}, Point{4, 2})) // ee
	assert.Equal(t, 2.356194490192345, angle(Point{2, 2}, Point{4, 4}))  // se
	assert.Equal(t, 3.141592653589793, angle(Point{2, 2}, Point{2, 4}))  // s
	assert.Equal(t, 3.9269908169872414, angle(Point{2, 2}, Point{0, 4})) // sw
	assert.Equal(t, 4.71238898038469, angle(Point{2, 2}, Point{0, 2}))   // w
	assert.Equal(t, 5.497787143782138, angle(Point{2, 2}, Point{0, 0}))  // nw
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		TestCase{"test1a.txt", 8, Point{3, 4}},
		TestCase{"test1b.txt", 33, Point{5, 8}},
		TestCase{"test1c.txt", 35, Point{1, 2}},
		TestCase{"test1d.txt", 41, Point{6, 3}},
		TestCase{"test1e.txt", 210, Point{11, 13}},
	}
	for _, tc := range tests {
		lines := ReadLines(tc.file)
		g := NewGame(lines)
		assert.Equal(t, tc.part1, g.Part1())
		assert.Equal(t, tc.best, g.best)
	}
}

func TestPart2(t *testing.T) {
	lines := ReadLines("test2a.txt")
	for i, v := range []int{801, 900, 901, 1000, 902, 1101, 1201, 1102, 1501} {
		g := NewGame(lines)
		assert.Equal(t, Point{8, 3}, g.best)
		res := g.Part2(i + 1)
		assert.Equal(t, v, res)
	}
}
