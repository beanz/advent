package aoc

import (
	assert "github.com/stretchr/testify/require"
	"testing"
)

func TestFP3(t *testing.T) {
	tests := []struct {
		x, y, z int16
	}{
		{10, 20, 30},
		{-10, -20, -30},
	}
	for _, tc := range tests {
		fp3 := NewFP3(tc.x, tc.y, tc.z)
		x, y, z := fp3.XYZ()
		assert.Equal(t, tc.x, x)
		assert.Equal(t, tc.y, y)
		assert.Equal(t, tc.z, z)
	}
}

func TestFP3Add(t *testing.T) {
	tests := []struct {
		x, y, z, ox, oy, oz int16
	}{
		{10, 20, 30, 1, 2, 3},
		{-10, -20, -30, 1, 2, 3},
		{10, 20, 30, -1, -2, -3},
		{-10, -20, -30, -1, -2, -3},
	}
	for _, tc := range tests {
		fp3 := NewFP3(tc.x, tc.y, tc.z)
		ofp3 := NewFP3(tc.ox, tc.oy, tc.oz)
		n := fp3.Add(ofp3)
		x, y, z := n.XYZ()
		assert.Equal(t, tc.x+tc.ox, x)
		assert.Equal(t, tc.y+tc.oy, y)
		assert.Equal(t, tc.z+tc.oz, z)
	}
}

func TestFP3Sub(t *testing.T) {
	tests := []struct {
		x, y, z, ox, oy, oz int16
	}{
		{10, 20, 30, 1, 2, 3},
		{-10, -20, -30, 1, 2, 3},
		{10, 20, 30, -1, -2, -3},
		{-10, -20, -30, -1, -2, -3},
	}
	for _, tc := range tests {
		fp3 := NewFP3(tc.x, tc.y, tc.z)
		ofp3 := NewFP3(tc.ox, tc.oy, tc.oz)
		n := fp3.Sub(ofp3)
		x, y, z := n.XYZ()
		assert.Equal(t, tc.x-tc.ox, x)
		assert.Equal(t, tc.y-tc.oy, y)
		assert.Equal(t, tc.z-tc.oz, z)
	}
}
