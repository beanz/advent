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
	// Part 1: 122-12==0-01=00-0=02
}

func TestParts(t *testing.T) {
	tests := []struct {
		file string
		data []byte
		p1   string
	}{
		{"test1.txt", test1, "              2=-1=0"},
		{"input.txt", input, "122-12==0-01=00-0=02"},
	}
	for _, tc := range tests {
		p1 := Part(tc.data)
		assert.Equal(t, tc.p1, fmt.Sprintf("%s", p1), tc.file)
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
