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

func ExampleMain() {
	main()
	//Output:
	// Part 1: 5486
	// Part 2: 20210
}

func TestIndex(t *testing.T) {
	tests := []struct {
		file   string
		data   []byte
		x, y   int
		def bool
		exp    int
	}{
		{"test1.txt", test1, 2, 2, false, 34},
		{"test1.txt", test1, -1,-1, false, 1},
		{"test1.txt", test1, 0,-1, false, 2},
		{"test1.txt", test1, -1,0, false, 9},
		{"test1.txt", test1, 2, 2, true, 34},
		{"test1.txt", test1, -1,-1, true, 1},
		{"test1.txt", test1, 0,-1, true, 2},
		{"test1.txt", test1, -1,0, true, 9},
		{"input.txt", input, 2, 2, false, 450},
		{"input.txt", input, -1,-1, false, 0},
		{"input.txt", input, 0,-1, false, 1},
		{"input.txt", input, -1,0, false, 1},
		{"input.txt", input, 100,100, false, 0},
		{"input.txt", input, 99,100, false, 0},
		{"input.txt", input, 100,99, false, 256},
		{"input.txt", input, 2, 2, true, 450},
		{"input.txt", input, -1,-1, true, 510},
		{"input.txt", input, 0,-1, true, 509},
		{"input.txt", input, -1,0, true, 503},
		{"input.txt", input, 100,100, true, 255},
		{"input.txt", input, 99,100, true, 127},
		{"input.txt", input, 100,99, true, 479},
	}
	for _, tc := range tests {
		name := fmt.Sprintf("%s %d,%d %v", tc.file, tc.x, tc.y, tc.def)
		g := NewImage(tc.data)
		assert.Equal(t, tc.exp, g.index(tc.x, tc.y, g.lookup[0] && tc.def),
			name)
	}
}

type TestCase struct {
	file   string
	data   []byte
	p1, p2 int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", test1, 35, 3351},
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
