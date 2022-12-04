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
	// Part 1: 66487
	// Part 2: 197301
}

func TestParts(t *testing.T) {
	tests := []struct {
		file string
		data []byte
		p1   int
		p2   int
	}{
		{"test1.txt", test1, 24000, 45000},
		{"input.txt", input, 66487, 197301},
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
