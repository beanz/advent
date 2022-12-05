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
	// Part 1: PTWLTDSJV
	// Part 2: WZMFVGGZP
}

func TestParts(t *testing.T) {
	tests := []struct {
		file   string
		data   []byte
		p1, p2 string
	}{
		{"test1.txt", test1, "CMZ      ", "MCD      "},
		{"input.txt", input, "PTWLTDSJV", "WZMFVGGZP"},
	}
	for _, tc := range tests {
		p1, p2 := Parts(tc.data)
		assert.Equal(t, tc.p1, fmt.Sprintf("%s", p1), tc.file)
		assert.Equal(t, tc.p2, fmt.Sprintf("%s", p2), tc.file)
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
