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

func TestScanUint(t *testing.T) {
	in := []byte("10XY20ab30")
	i := 0
	n, i := ScanUint(in, i)
	assert.Equal(t, 10, n, "first number")
	assert.Equal(t, 2, i, "first index")
	i+=2 // skip 'XY'
	n, i = ScanUint(in, i)
	assert.Equal(t, 20, n, "second number")
	assert.Equal(t, 6, i, "second index")
	i+=2 // skip 'ab'
	n, i = ScanUint(in, i)
	assert.Equal(t, 30, n, "third number")
	assert.Equal(t, 10, i, "third index")
	n, i = ScanUint(in, i)
	assert.Equal(t, 0, n, "end of string number")
	assert.Equal(t, 10, i, "end of string index")
}
