package main

import (
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/beanz/advent/lib-go/tester"
)

type TestCase struct {
	in  string
	res int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{">", 2},
		{"^>v<", 4},
		{"^v^v^v^v^v", 2},
	}
	for _, tc := range tests {
		p1, _ := Parts([]byte(tc.in))
		assert.Equal(t, tc.res, p1, tc.in)
	}
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"^v", 3},
		{"^>v<", 3},
		{"^v^v^v^v^v", 11},
	}
	for _, tc := range tests {
		_, p2 := Parts([]byte(tc.in))
		assert.Equal(t, tc.res, p2, tc.in)
	}
}

func TestParts(t *testing.T) {
	tester.RunWithArgs(t, Parts)
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
