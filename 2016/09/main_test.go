package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func ExampleMain() {
	main()
	//Output:
	// Part 1: 74532
	// Part 2: 11558231665
}

func TestDecompress(t *testing.T) {
	tests := []struct {
		in string
		len int
	}{
		{ "ADVENT",	 6 },
		{ "A(1x5)BC", 7 },
		{ "(3x3)XYZ", 9 },
		{ "A(2x2)BCD(2x2)EFG", 11 },
		{ "(6x1)(1x3)A", 6 },
		{ "X(8x2)(3x3)ABCY", 18 },
	}
	for _, tc := range tests {
		t.Run(tc.in, func(t *testing.T) {
			assert.Equal(t, tc.len, Decompress([]byte(tc.in)), tc.in)
		})
	}
}

func TestDecompressV2(t *testing.T) {
	tests := []struct {
		in string
		len int
	}{
		{ "ADVENT",	 6 },
		{ "A(1x5)BC", 7 },
		{ "(3x3)XYZ", 9 },
		{ "A(2x2)BCD(2x2)EFG", 11 },
		{ "X(8x2)(3x3)ABCY", 20 },
		{ "(27x12)(20x12)(13x14)(7x10)(1x12)A", 241920 },
		{ "(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN", 445 },
	}
	for _, tc := range tests {
		t.Run(tc.in, func(t *testing.T) {
			assert.Equal(t, tc.len, DecompressV2([]byte(tc.in)), tc.in)
		})
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
