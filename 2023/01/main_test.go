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

//go:embed input.txt
var safeinput []byte

func ExampleMain() {
	main()
	//Output:
	// Part 1: 54390
	// Part 2: 54277
}

func TestParts(t *testing.T) {
	tests := []struct {
		file   string
		data   []byte
		p1, p2 int
	}{
		{"test1.txt", test1, 142, 142},
		{"test2.txt", test2, 209, 281},
		{"input.txt", input, 54390, 54277},
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
