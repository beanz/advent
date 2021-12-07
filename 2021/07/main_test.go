package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

type TestCase struct {
	file string
	fn   func(int, int) int
	ans  int
}

func TestMinFuel(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", Fuel, 37},
		{"input.txt", Fuel, 336701},
		{"test1.txt", Fuel2, 168},
		{"input.txt", Fuel2, 95167302},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans,
			MinFuel(ReadIntsFromFile(tc.file), tc.fn), tc.file)
	}
}
