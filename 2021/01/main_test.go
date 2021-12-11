package main

import (
	_ "embed"
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

//go:embed test1.txt
var test1 []byte

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
		data []byte
		ans  int
	}{
		{"test1.txt", test1, 7},
		{"input.txt", input, 1342},
	}
	for _, tc := range tests {
		assert.Equal(t,
			tc.ans, NewGame(InputBytes(tc.data)).Part1(), tc.file)
	}
}

func TestPart2(t *testing.T) {
	tests := []struct {
		file string
		data []byte
		ans  int
	}{
		{"test1.txt", test1, 5},
		{"input.txt", input, 1378},
	}
	for _, tc := range tests {
		assert.Equal(t,
			tc.ans, NewGame(InputBytes(tc.data)).Part2(), tc.file)
	}
}

func TestFun(t *testing.T) {
	tests := []struct {
		file   string
		data   []byte
		window int
		ans    int
	}{
		{"test1.txt", test1, 1, 7},
		{"input.txt", input, 1, 1342},
		{"test1.txt", test1, 3, 5},
		{"input.txt", input, 3, 1378},
	}
	for _, tc := range tests {
		assert.Equal(t,
			tc.ans, NewGame(InputBytes(tc.data)).Fun(tc.window), tc.file)
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
