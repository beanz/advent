package main

import (
	_ "embed"
	"fmt"
	assert "github.com/stretchr/testify/require"
	"testing"
)

//go:embed test0.txt
var test0 []byte

//go:embed test1.txt
var test1 []byte

//go:embed test2.txt
var test2 []byte

//go:embed input.txt
var safeinput []byte

func ExampleMain() {
	main()
	//Output:
	// Part 1: 18282
	// Part 2: 50132
}

func TestPosition(t *testing.T) {
	tests := []struct {
		x, y int
		pos  int
	}{
		{1, 1, 0},
		{2, 1, 1},
		{3, 1, 2},
		{10, 1, 9},
		{11, 1, 10},
		{3, 2, 11},
		{3, 3, 15},
		{3, 4, 19},
		{3, 5, 23},
		{5, 2, 12},
		{5, 3, 16},
		{5, 4, 20},
		{5, 5, 24},
		{7, 2, 13},
		{7, 3, 17},
		{7, 4, 21},
		{7, 5, 25},
		{9, 2, 14},
		{9, 3, 18},
		{9, 4, 22},
		{9, 5, 26},
	}
	for _, tc := range tests {
		p := NewPosition(tc.x, tc.y)
		assert.Equal(t, tc.pos, int(p), "pos %d,%d", tc.x, tc.y)
		x, y := p.XY()
		assert.Equal(t, tc.x, x, "x %d,%d", tc.x, tc.y)
		assert.Equal(t, tc.y, y, "y %d,%d", tc.x, tc.y)
	}
	assert.Equal(t, "9,3", NewPosition(9, 3).String())
}

func TestAmphipod(t *testing.T) {
	a := NewAmphipod('A')
	b := NewAmphipod('B')
	c := NewAmphipod('C')
	d := NewAmphipod('D')
	assert.Equal(t, 3, a.hx, "A home x")
	assert.Equal(t, 5, b.hx, "B home x")
	assert.Equal(t, 7, c.hx, "C home x")
	assert.Equal(t, 9, d.hx, "D home x")
	assert.Equal(t, 1, a.me, "A move energy")
	assert.Equal(t, 10, b.me, "B move energy")
	assert.Equal(t, 100, c.me, "C move energy")
	assert.Equal(t, 1000, d.me, "D move energy")
}

func TestIsHome(t *testing.T) {
	tests := []struct {
		file string
		data []byte
		x, y int
		ans  bool
	}{
		{"test0.txt", test0, 3, 2, false},
		{"test0.txt", test0, 3, 3, true},
		{"test0.txt", test0, 5, 2, true},
		{"test0.txt", test0, 5, 3, true},
		{"test0.txt", test0, 7, 2, true},
		{"test0.txt", test0, 7, 3, true},
		{"test0.txt", test0, 9, 2, false},
		{"test0.txt", test0, 9, 3, true},
		{"test2.txt", test2, 3, 2, false},
	}
	for _, tc := range tests {
		g := NewGame(tc.data)
		assert.Equal(t,
			tc.ans, g.init.IsHome(NewPosition(tc.x, tc.y)),
			fmt.Sprintf("%s %d,%d", tc.file, tc.x, tc.y))
	}
}

func TestDone(t *testing.T) {
	g := NewGame(test0)
	assert.False(t, g.init.Done())
	g.init.m[NewPosition(3, 2)], g.init.m[NewPosition(9, 2)] =
		g.init.m[NewPosition(9, 2)], g.init.m[NewPosition(3, 2)]
	assert.True(t, g.init.Done())
}

func TestHome(t *testing.T) {
	g := NewGame(test0)
	assert.Equal(t, NoPosition, g.init.Home(NewPosition(9, 2)),
		"no free home space")
	delete(g.init.m, NewPosition(3, 3))
	assert.Equal(t, "3,3", g.init.Home(NewPosition(9, 2)).String(),
		"best home")
	g = NewGame(test0)
	delete(g.init.m, NewPosition(3, 2))
	assert.Equal(t, "3,2", g.init.Home(NewPosition(9, 2)).String(),
		"second best home")
}

func TestPathClear(t *testing.T) {
	g := NewGame(test0)
	_, clear := g.init.PathClear(NewPosition(9, 2), NewPosition(3, 2))
	assert.False(t, clear)
	delete(g.init.m, NewPosition(3, 2))
	cost, clear := g.init.PathClear(NewPosition(9, 2), NewPosition(3, 2))
	assert.True(t, clear)
	assert.Equal(t, 8, cost)
}

func TestMoves(t *testing.T) {
	g := NewGame(test0)
	assert.Equal(t, "[1,1/9 2,1/8 4,1/6 6,1/4 8,1/2 10,1/2 11,1/3]",
		fmt.Sprintf("%v", g.init.Moves(NewPosition(9, 2))))
	assert.Equal(t, "[]",
		fmt.Sprintf("%v", g.init.Moves(NewPosition(3, 3))))
	g = NewGame(test0)
	g.init.m[NewPosition(10, 1)] = g.init.m[NewPosition(9, 2)]
	delete(g.init.m, NewPosition(9, 2))
	assert.Equal(t, "[]", fmt.Sprintf("%v", g.init.Moves(NewPosition(10, 1))))
	delete(g.init.m, NewPosition(3, 2))
	assert.Equal(t, "[3,2/8]",
		fmt.Sprintf("%v", g.init.Moves(NewPosition(10, 1))))
}

func TestPart1(t *testing.T) {
	tests := []struct {
		file string
		data []byte
		ans  int
	}{
		{"test0.txt", test0, 8010},
		{"test1.txt", test1, 12521},
		{"test2.txt", test2, 14016},
		{"input.txt", input, 18282},
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
		{"test0.txt", test0, 32016},
		{"test1.txt", test1, 44169},
		{"test2.txt", test2, 42824},
		{"input.txt", input, 50132},
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
