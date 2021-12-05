package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestBingo(t *testing.T) {
	tests := []struct {
		file string
		p1   int
		p2   int
	}{
		{"test1.txt", 4512, 1924},
		{"input.txt", 63552, 9020},
	}
	for _, tc := range tests {
		p1, p2 := NewHall(ReadChunks(tc.file)).Bingo()
		assert.Equal(t, tc.p1, p1, tc.file+" part 1")
		assert.Equal(t, tc.p2, p2, tc.file+" part 2")
	}
}
