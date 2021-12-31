package main

import (
	_ "embed"
	"fmt"
	assert "github.com/stretchr/testify/require"
	"testing"
)

//go:embed test1.txt
var test1 []byte

type TestCase struct {
	file string
	data []byte
	days int
	ans  int
}

func TestFish(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", test1, 1, 5},
		{"test1.txt", test1, 2, 6},
		{"test1.txt", test1, 3, 7},
		{"test1.txt", test1, 4, 9},
		{"test1.txt", test1, 5, 10},
		{"test1.txt", test1, 8, 10},
		{"test1.txt", test1, 9, 11},
		{"test1.txt", test1, 10, 12},
		{"test1.txt", test1, 11, 15},
		{"test1.txt", test1, 12, 17},
		{"test1.txt", test1, 13, 19},
		{"test1.txt", test1, 18, 26},
		{"test1.txt", test1, 80, 5934},
		{"test1.txt", test1, 256, 26984457539},
		{"input.txt", input, 80, 365131},
		{"input.txt", input, 256, 1650309278600},
	}
	for _, tc := range tests {
		d := make([]byte, len(tc.data))
		copy(d, tc.data)
		p1, _ := NewSchool(d).Fish(tc.days, tc.days)
		assert.Equal(t, tc.ans, p1,
			fmt.Sprintf("%s x %d days", tc.file, tc.days))
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
