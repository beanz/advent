package main

import (
	_ "embed"
	assert "github.com/stretchr/testify/require"
	"testing"
)

//go:embed test1.txt
var test1 []byte

//go:embed input.txt
var safeinput []byte

type TestCase struct {
	file string
	data []byte
	p1   int
	p2   string
}

//go:embed p2answer.txt
var p2OfInput string

func TestParts(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", test1, 17, "#####\n#   #\n#   #\n#   #\n#####\n"},
		{"input.txt", input, 747, p2OfInput},
	}
	for _, tc := range tests {
		p1, p2 := NewGame(tc.data).Parts()
		assert.Equal(t, tc.p1, p1, tc.file+" part 1")
		assert.Equal(t, tc.p2, p2, tc.file+" part 2")
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
