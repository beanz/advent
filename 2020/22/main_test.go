package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestKey(t *testing.T) {
	seen := make(map[int]bool)
	k1 := Key([]int{27, 47, 28}, []int{34, 29, 39, 32, 26, 24, 36, 19, 43, 31, 35, 30})
	assert.False(t, seen[k1], "key not present to begin with")
	seen[k1] = true
	assert.True(t, seen[k1], "key present after add")
	k2 := Key([]int{27, 47, 28}, []int{36, 32, 43, 26, 35, 24, 30, 29, 34, 19, 39, 31})
	assert.False(t, seen[k2], "key not present to begin with")
	seen[k2] = true
	assert.True(t, seen[k2], "key present after add")
}

type TestCase struct {
	file string
	ans  int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 306},
		{"input.txt", 32856},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, NewGame(ReadChunks(tc.file)).Part1(), tc.file)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 291},
		{"input.txt", 33805},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, NewGame(ReadChunks(tc.file)).Part2(), tc.file)
	}
}

var result int

func benchKey(b *testing.B, d1, d2 []int) {
	var r int
	for n := 0; n < b.N; n++ {
		r = Key(d1, d2)
	}
	result = r
}

func BenchmarkShortKey(b *testing.B) {
	benchKey(b, []int{9, 2, 6, 3, 1}, []int{5, 8, 4, 7, 10})
}

func BenchmarkLongKey(b *testing.B) {
	benchKey(b,
		[]int{41, 48, 12, 6, 1, 25, 47, 43, 4, 35, 10, 13,
			23, 39, 22, 28, 44, 42, 32, 31, 24, 50, 34, 29, 14},
		[]int{36, 49, 11, 16, 20, 17, 26, 30, 18, 5, 2, 38,
			7, 27, 21, 9, 19, 15, 8, 45, 37, 40, 33, 46, 3},
	)
}

var p2 int

func BenchmarkPart2(b *testing.B) {
	g := NewGame(ReadChunks("input.txt"))
	var r int
	for n := 0; n < b.N; n++ {
		r = g.Part2()
	}
	p2 = r
}
