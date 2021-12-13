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
	ans  int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", test1, 1514},
		{"input.txt", input, 185371},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, NewKiosk(tc.data).Part1(), tc.file)
	}
}

func TestRealName(t *testing.T) {
	r := Room{[]byte("qzmt-zixmtkozy-ivhz"), 343, []byte{}, nil}
	assert.Equal(t, "very encrypted name", r.RealName())
}

func TestPart2(t *testing.T) {
	tests := []TestCase{
		{"input.txt", input, 984},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.ans, NewKiosk(tc.data).Part2(), tc.file)
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
