package main

import (
	_ "embed"
	"fmt"
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
	// Part 1: 1565
	// Part 2: 10672
}

func TestSolve(t *testing.T) {
	tests := []struct {
		file string
		data []byte
		bp   int
		time int
		res  int
	}{
		{"test1.txt", test1, 1, 18, 0},
		{"test1.txt", test1, 1, 19, 1},
		{"test1.txt", test1, 1, 24, 9},
		{"test1.txt", test1, 2, 24, 12},
		{"test1.txt", test1, 1, 32, 56},
		{"test1.txt", test1, 2, 32, 62},
		{"input.txt", input, 1, 32, 29},
		{"input.txt", input, 2, 32, 23},
		{"input.txt", input, 3, 32, 16},
	}
	for _, tc := range tests {
		data := Read(tc.data)
		assert.Equal(t, tc.res, Solve(data[tc.bp-1], tc.time),
			fmt.Sprintf("%s[%d] in %d", tc.file, tc.bp, tc.time))
	}
}

func TestParts(t *testing.T) {
	tests := []struct {
		file   string
		data   []byte
		p1, p2 int
	}{
		{"test1.txt", test1, 33, 56 * 62},
		{"input.txt", input, 1565, 10672},
	}
	for _, tc := range tests {
		p1, p2 := Parts(tc.data)
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
