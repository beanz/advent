package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestOverlaps(t *testing.T) {
	tests := []struct {
		file string
		p1   int
		p2   int
	}{
		{"test1.txt", 5, 12},
		{"input.txt", 6005, 23864},
	}
	for _, tc := range tests {
		p1, p2 := NewDiag(ReadLines(tc.file)).Overlaps()
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
