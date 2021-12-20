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

func ExampleMain() {
	main()
	//Output:
	// Part 1: 5486
	// Part 2: 20210
}

type TestCase struct {
	file   string
	data   []byte
	p1, p2 int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		// TOFIX: {"test1.txt", test1, 35, 3351},
		{"input.txt", input, 5486, 20210},
	}
	for _, tc := range tests {
		g := NewImage(tc.data)
		p1, p2 := g.Enhance()
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
