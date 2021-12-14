package main

import (
	_ "embed"
	assert "github.com/stretchr/testify/require"
	"testing"
)

//go:embed test1.txt
var test1 []byte

//go:embed input.txt
var safeinput []byte

type TestCase struct {
	file   string
	data   []byte
	p1, p2 int
}

func TestParts(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", test1, 1588, 2188189693529},
		{"input.txt", input, 2891, 4607749009683},
	}
	for _, tc := range tests {
		p1, p2 := NewPolymer(tc.data).Parts()
		assert.Equal(t, tc.p1, p1, tc.file)
		assert.Equal(t, tc.p2, p2, tc.file)
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		b.StopTimer()
		copy(input, safeinput)
		b.StartTimer()
		main()
	}
}
