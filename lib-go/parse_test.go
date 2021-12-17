package aoc

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestFastSignedInts(t *testing.T) {
	tests := []struct {
		name string
		in []byte
		exp  []int
	}{
		{
			name: "with newline",
			in: []byte("target area: x=287..309, y=-76..-48\n"),
			exp: []int{287, 309, -76, -48},
		},
		{
			name: "without newline",
			in: []byte("target area: x=287..309, y=-76..-48"),
			exp: []int{287, 309, -76, -48},
		},
		{
			name: "multiline",
			in: []byte("287..309\n-76..-48\n"),
			exp: []int{287, 309, -76, -48},
		},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.exp, FastSignedInts(tc.in, 4), tc.name);
	}
}
