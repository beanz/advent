package main

import (
	. "github.com/beanz/advent/lib-go"
	assert "github.com/stretchr/testify/require"
	"testing"
)

func TestTransformType(t *testing.T) {
	tests := []struct {
		in, out string
	}{
		{
			in:  "swap position 4 with position 2",
			out: "swap pos 4 2",
		},
		{
			in:  "swap letter e with letter f",
			out: "swap letter e f",
		},
		{
			in:  "rotate left 3 steps",
			out: "rotate left 3",
		},
		{
			in:  "rotate right 5 steps",
			out: "rotate right 5",
		},
		{
			in:  "rotate based on position of letter d",
			out: "rotate base d",
		},
		{
			in:  "reverse positions 2 through 5",
			out: "reverse 2-5",
		},
		{
			in:  "move position 7 to position 5",
			out: "move 7 to 5",
		},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.out, NewTransform(tc.in).String())
	}
}

func TestTransform(t *testing.T) {
	tests := []struct {
		in, out string
	}{
		{
			in:  "swap position 4 with position 0",
			out: "ebcda",
		},
		{
			in:  "swap letter d with letter b",
			out: "edcba",
		},
		{
			in:  "reverse positions 0 through 4",
			out: "abcde",
		},
		{
			in:  "rotate left 1 step",
			out: "bcdea",
		},
		{
			in:  "move position 1 to position 4",
			out: "bdeac",
		},
		{
			in:  "move position 3 to position 0",
			out: "abdec",
		},
		{
			in:  "rotate based on position of letter b",
			out: "ecabd",
		},
		{
			in:  "rotate based on position of letter d",
			out: "decab",
		},
	}
	s := "abcde"
	for _, tc := range tests {
		s = NewTransform(tc.in).ApplyTo(s)
		assert.Equal(t, tc.out, s, tc.in)
	}
}

func TestPart1(t *testing.T) {
	game := NewGame(ReadLines("test.txt"))
	assert.Equal(t, "fbdecgha", game.Part1("abcdefgh"))
	game = NewGame(ReadLines("input.txt"))
	assert.Equal(t, "gcedfahb", game.Part1("abcdefgh"))
}

func TestPart2(t *testing.T) {
	game := NewGame(ReadLines("test.txt"))
	assert.Equal(t, "efghdabc", game.Part2("fbgdceah"))
	game = NewGame(ReadLines("input.txt"))
	assert.Equal(t, "hegbdcfa", game.Part2("fbgdceah"))
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
