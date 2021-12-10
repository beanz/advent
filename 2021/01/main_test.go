package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestWindows(t *testing.T) {
	assert.Equal(t, [][]int{{1}, {2}, {3}, {4}},
		Windows([]int{1, 2, 3, 4}, 1))
	assert.Equal(t, [][]int{{1, 2}, {2, 3}, {3, 4}},
		Windows([]int{1, 2, 3, 4}, 2))
	assert.Equal(t, [][]int{{1, 2, 3}, {2, 3, 4}},
		Windows([]int{1, 2, 3, 4}, 3))
}

func TestPart1(t *testing.T) {
	tests := []struct {
		file string
		ans  int
	}{
		{"test1.txt", 7},
		{"input.txt", 1342},
	}
	for _, tc := range tests {
		assert.Equal(t,
			tc.ans, NewGame(ReadIntsFromFile(tc.file)).Part1(), tc.file)
	}
}

func TestPart2(t *testing.T) {
	tests := []struct {
		file string
		ans  int
	}{
		{"test1.txt", 5},
		{"input.txt", 1378},
	}
	for _, tc := range tests {
		assert.Equal(t,
			tc.ans, NewGame(ReadIntsFromFile(tc.file)).Part2(), tc.file)
	}
}

func TestFun(t *testing.T) {
	tests := []struct {
		file   string
		window int
		ans    int
	}{
		{"test1.txt", 1, 7},
		{"input.txt", 1, 1342},
		{"test1.txt", 3, 5},
		{"input.txt", 3, 1378},
	}
	for _, tc := range tests {
		assert.Equal(t,
			tc.ans, NewGame(ReadIntsFromFile(tc.file)).Fun(tc.window), tc.file)
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
