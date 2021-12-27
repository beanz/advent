package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func ExampleMain() {
	main()
	//Output:
	// Part 1: 931
	// Part 2: 609
}

func TestPlay(t *testing.T) {
	tests := []struct {
		in     int
		p1, p2 int
	}{
		{111111, 1, 0},
		{223450, 0, 0},
		{123789, 0, 0},
		{112233, 1, 1},
		{123444, 1, 0},
		{111122, 1, 1},
	}
	for _, tc := range tests {
		p1, p2 := Parts(tc.in, tc.in)
		assert.Equal(t, tc.p1, p1, "part 1: %d", tc.in)
		assert.Equal(t, tc.p2, p2, "part 2: %d", tc.in)
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
