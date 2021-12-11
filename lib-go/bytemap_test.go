package aoc

import (
	"fmt"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestByteMapContains(t *testing.T) {
	var test1 = []byte(
		"2199943210\n3987894921\n9856789892\n8767896789\n9899965678\n",
	)
	tests := []struct {
		x, y int
		exp  bool
	}{
		{x: 0, y: 0, exp: true},
		{x: -1, y: 0, exp: false},
		{x: 9, y: 0, exp: true},
		{x: 10, y: 0, exp: false},
		{x: 0, y: -1, exp: false},
		{x: 0, y: 4, exp: true},
		{x: 0, y: 5, exp: false},
	}
	lt := NewByteMap(test1)
	for _, tc := range tests {
		assert.Equal(t, tc.exp,
			lt.Contains(tc.x+tc.y*lt.w), fmt.Sprintf("%d,%d", tc.x, tc.y))
	}
}
