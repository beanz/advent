package main

import (
	_ "embed"
	"testing"

	assert "github.com/stretchr/testify/require"
)

//go:embed test1.txt
var test1 []byte

//go:embed test2.txt
var test2 []byte

//go:embed test3.txt
var test3 []byte

//go:embed test4.txt
var test4 []byte

//go:embed test5.txt
var test5 []byte

//go:embed input.txt
var safeinput []byte

func ExampleMain() {
	main()
	//Output:
	// Part 1: 7086
	// Part 2: 317
}

func TestParts(t *testing.T) {
	tests := []struct {
		file   string
		data   []byte
		p1, p2 int
	}{
		{"test1.txt", test1, 4, 1},
		{"test2.txt", test2, 8, 1},
		{"test3.txt", test3, 23, 4},
		{"test4.txt", test4, 70, 8},
		{"test5.txt", test5, 80, 10},
		{"input.txt", input, 7086, 317},
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
