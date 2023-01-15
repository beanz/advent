package main

import (
	_ "embed"
	"testing"

	assert "github.com/stretchr/testify/require"
)

//go:embed test.txt
var test []byte

//go:embed input-amf.txt
var input2 []byte

//go:embed input.txt
var safeinput []byte

func ExampleMain() {
	main()
	//Output:
	// Part 1: 505
	// Part 2: 72330
}

func TestParts(t *testing.T) {
	tests := []struct {
		file string
		data []byte
		p1   Int
		p2   Int
	}{
		{"test.txt", test, 3, 2},
		{"input.txt", input, 505, 72330},
		{"input-amf.txt", input2, 490, 70357},
	}
	for _, tc := range tests {
		p1, p2 := Parts(tc.data)
		assert.Equal(t, tc.p1, p1, "part 1: %s", tc.file)
		assert.Equal(t, tc.p2, p2, "part 2: %s", tc.file)
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
