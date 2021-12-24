package main

import (
	_ "embed"
	assert "github.com/stretchr/testify/require"
	"testing"
)

//go:embed input.txt
var safeinput []byte

func ExampleMain() {
	main()
	//Output:
	// Part 1: 96929994293996
	// Part 2: 41811761181141
}

func TestSolve(t *testing.T) {
	tests := []struct {
		file string
		data []byte
		p1, p2  int
	}{
		{"input.txt", input, 96929994293996, 41811761181141 },
	}
	for _, tc := range tests {
		p1, p2 := NewALU(tc.data).Solve()
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
