package main

import (
	_ "embed"
	assert "github.com/stretchr/testify/require"
	"testing"
)

//go:embed test1.txt
var test1 []byte

//go:embed test2.txt
var test2 []byte

//go:embed test3.txt
var test3 []byte

//go:embed input.txt
var safeinput []byte

type TestCase struct {
	file string
	data []byte
	p1, p2  int
}

func TestSolve(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", test1, 12, 1357},
		{"test2.txt", test2, 38, 1357},
		{"test3.txt", test3, 79, 3621},
	}
	for _, tc := range tests {
		g := NewGame(tc.data)
		p1, p2 := g.Solve()
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
