package main

import (
	_ "embed"
	"fmt"
	assert "github.com/stretchr/testify/require"
	"testing"
)

//go:embed test1.txt
var test1 []byte

//go:embed input.txt
var safeinput []byte

type TestCase struct {
	file string
	data []byte
	dim uint16
	ans  uint16
}

func TestSolve(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", test1, 1, 40 },
		{"test1.txt", test1, 2, 101 },
		{"test1.txt", test1, 3, 170 },
		{"test1.txt", test1, 4, 248 },
		{"test1.txt", test1, 5, 315 },
		{"test1.txt", test1, 10, 592 },
		{"input.txt", input, 1, 595 },
		{"input.txt", input, 5, 2914 },
	}
	if !testing.Short() {
		tests = append(tests,TestCase{"input.txt", input, 10, 5729 });
	}
	for _, tc := range tests {
		t.Run(fmt.Sprintf("%s x %d", tc.file, tc.dim), func (t *testing.T) {
			c := NewCave(tc.data)
			c.SetDim(tc.dim)
			assert.Equal(t, tc.ans, c.Solve(), tc.file)
		})
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
