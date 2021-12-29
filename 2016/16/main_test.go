package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func ExampleMain() {
	main()
	//Output:
	// Part 1: 00000100100001100
	// Part 2: 00011010100010010
}

func TestDragon(t *testing.T) {
	tests := []struct {
		in  string
		len int
		out string
	}{
		{"1", 3, "100"},
		{"0", 3, "001"},
		{"11111", 11, "11111000000"},
		{"111100001010", 25, "1111000010100101011110000"},
	}
	for _, tc := range tests {
		g := NewGame([]byte(tc.in))
		assert.Equal(t, tc.out, PrettyDragon(g.Dragon(tc.len)),
			"%s x %d", tc.in, tc.len)
	}
}

func TestChecksum(t *testing.T) {
	tests := []struct {
		in  string
		out string
	}{
		{"110010110100", "100"},
		{"10000011110010000111", "01100"},
	}
	for _, tc := range tests {
		d := NewGame([]byte(tc.in))
		assert.Equal(t, tc.out, Checksum(d.input), tc.in)
	}
}

func TestPlay(t *testing.T) {
	assert.Equal(t, "01100", NewGame([]byte("10000")).Play(20))
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
