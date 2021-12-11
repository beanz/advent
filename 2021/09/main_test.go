package main

import (
	_ "embed"
	"github.com/stretchr/testify/assert"
	"testing"
)

//go:embed test1.txt
var test1 []byte

//go:embed input.txt
var safeinput []byte

type TestCase struct {
	file   string
	data   []byte
	p1, p2 int
}

func TestParts(t *testing.T) {
	if string(input[:10]) != "5456898789" {
		copy(input, safeinput)
	}
	tests := []TestCase{
		{"test1.txt", test1, 15, 1134},
		{"input.txt", input, 456, 1047744},
	}
	for _, tc := range tests {
		p1, p2 := NewLavaTubes(tc.data).Calc()
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
