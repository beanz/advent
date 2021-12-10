package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

type TestCase struct {
	file string
	ans  int
}

func TestValidYear(t *testing.T) {
	assert.True(t,
		validYear("2002", 1920, 2002), "Birth year in range")
	assert.False(t,
		validYear("2003", 1920, 2002), "Birth year out of in range")
}

func TestValidHeight(t *testing.T) {
	assert.True(t, validHeight("60in"), "Valid height in inches")
	assert.True(t, validHeight("190cm"), "Valid height in cm")
	assert.False(t, validHeight("190in"), "Too tall (in inches)")
	assert.False(t, validHeight("190"), "Height without units")
}

func TestValidHairColor(t *testing.T) {
	assert.True(t, validHairColor("#123abc"), "Valid hair color")
	assert.False(t, validHairColor("#123abz"), "Invalid hex in hair color")
	assert.False(t, validHairColor("123abc"), "Missing # in hair color")
}

func TestValidEyeColor(t *testing.T) {
	assert.True(t, validEyeColor("brn"), "Valid eye color")
	assert.False(t, validEyeColor("wat"), "Invalid eye color")
}

func TestValidPID(t *testing.T) {
	assert.True(t, validPID("000000001"), "Valid PID")
	assert.False(t, validPID("0123456789"), "Invalid PID")
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 2},
		{"test2.txt", 4},
		{"test3.txt", 4},
		{"input.txt", 213},
	}
	for _, tc := range tests {
		r := NewScanner(ReadChunks(tc.file)).Part1()
		assert.Equal(t, tc.ans, r)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 2},
		{"test2.txt", 0},
		{"test3.txt", 4},
		{"input.txt", 147},
	}
	for _, tc := range tests {
		r := NewScanner(ReadChunks(tc.file)).Part2()
		assert.Equal(t, tc.ans, r)
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
