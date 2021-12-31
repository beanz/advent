package main

import (
	_ "embed"
	"github.com/stretchr/testify/assert"
	"testing"
)

//go:embed "test1.txt"
var test1 []byte

func TestBingo(t *testing.T) {
	tests := []struct {
		file string
		data []byte
		p1   int
		p2   int
	}{
		{"test1.txt", test1, 4512, 1924},
		{"input.txt", input, 63552, 9020},
	}
	for _, tc := range tests {
		p1, p2 := NewHall(tc.data).Bingo()
		assert.Equal(t, tc.p1, p1, tc.file+" part 1")
		assert.Equal(t, tc.p2, p2, tc.file+" part 2")
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
