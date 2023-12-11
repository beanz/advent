package main

import (
	_ "embed"
	"testing"

	assert "github.com/stretchr/testify/require"
)

//go:embed test1.txt
var test1 []byte

//go:embed input.txt
var safeinput []byte

func ExampleMain() {
	main()
	//Output:
	// Part 1: 9918828
	// Part 2: 692506533832
}

func TestParts(t *testing.T) {
	tests := []struct {
		file   string
		data   []byte
		mul    int
		p1, p2 int
	}{
		{"test1.txt", test1, 10, 374, 1030},
		{"test1.txt", test1, 100, 374, 8410},
		{"test1.txt", test1, 1000000, 374, 82000210},
		{"input.txt", input, 1000000, 9918828, 692506533832},
	}
	for _, tc := range tests {
		p1, p2 := Parts(tc.data, tc.mul)
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
