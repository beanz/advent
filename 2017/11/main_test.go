package main

import (
	assert "github.com/stretchr/testify/require"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestParts(t *testing.T) {
	tests := []struct {
		s      string
		p1, p2 int
	}{
		{"ne,ne,ne", 3, 3},
		{"ne,ne,sw,sw", 0, 2},
		{"ne,ne,s,s", 2, 2},
		{"se,sw,se,sw,sw", 3, 3},
	}
	for _, tc := range tests {
		p1, p2 := Parts([]byte(tc.s))
		assert.Equal(t, tc.p1, p1, tc.s+" part 1")
		assert.Equal(t, tc.p2, p2, tc.s+" part 2")
	}
	p1, p2 := Parts(InputBytes(input))
	assert.Equal(t, 687, p1, "input.txt part 1")
	assert.Equal(t, 1483, p2, "input.txt part 2")
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
