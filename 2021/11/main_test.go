package main

import (
	_ "embed"
	assert "github.com/stretchr/testify/require"
	"testing"
)

//go:embed test0.txt
var test0 []byte

//go:embed test1.txt
var test1 []byte

//go:embed input.txt
var safeinput []byte

type TestCase struct {
	file   string
	data   []byte
	days   int
	p1, p2 int
}

func TestCalc(t *testing.T) {
	tests := []TestCase{
		{"test0.txt", test0, 1, 9, 6},
		{"test1.txt", test1, 100, 1656, 195},
		{"input.txt", input, 100, 1652, 220},
	}
	for _, tc := range tests {
		p1, p2 := NewOctopodes(tc.data).Calc(tc.days)
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
