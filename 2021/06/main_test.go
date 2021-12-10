package main

import (
	"fmt"
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

type TestCase struct {
	file string
	days int
	ans  int
}

func TestFish(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 1, 5},
		{"test1.txt", 2, 6},
		{"test1.txt", 3, 7},
		{"test1.txt", 4, 9},
		{"test1.txt", 5, 10},
		{"test1.txt", 8, 10},
		{"test1.txt", 9, 11},
		{"test1.txt", 10, 12},
		{"test1.txt", 11, 15},
		{"test1.txt", 12, 17},
		{"test1.txt", 13, 19},
		{"test1.txt", 18, 26},
		{"test1.txt", 80, 5934},
		{"test1.txt", 256, 26984457539},
		{"input.txt", 80, 365131},
		{"input.txt", 256, 1650309278600},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans,
			NewSchool(ReadFileInts(tc.file)).Fish(tc.days),
			fmt.Sprintf("%s x %d days", tc.file, tc.days))
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
