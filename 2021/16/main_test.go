package main

import (
	_ "embed"
	assert "github.com/stretchr/testify/require"
	"testing"
)

//go:embed test1a.txt
var test1a []byte
//go:embed test1b.txt
var test1b []byte
//go:embed test1c.txt
var test1c []byte
//go:embed test1d.txt
var test1d []byte
//go:embed test1e.txt
var test1e []byte
//go:embed test1f.txt
var test1f []byte
//go:embed test1g.txt
var test1g []byte

//go:embed test2a.txt
var test2a []byte
//go:embed test2b.txt
var test2b []byte
//go:embed test2c.txt
var test2c []byte
//go:embed test2d.txt
var test2d []byte
//go:embed test2e.txt
var test2e []byte
//go:embed test2f.txt
var test2f []byte
//go:embed test2g.txt
var test2g []byte
//go:embed test2h.txt
var test2h []byte

//go:embed input.txt
var safeinput []byte

type TestCase struct {
	file string
	data []byte
	p1, p2 int
}

func TestPart1(t *testing.T) {
	tests := []TestCase{
		{"test1a.txt", test1a, 6, 2021},
		{"test1b.txt", test1b, 9, 1},
		{"test1c.txt", test1c, 14, 3},
		{"test1d.txt", test1d, 16, 15},
		{"test1e.txt", test1e, 12, 46},
		{"test1f.txt", test1f, 23, 46},
		{"test1g.txt", test1g, 31, 54},
		{"test2a.txt", test2a, 14, 3},
		{"test2b.txt", test2b, 8, 54},
		{"test2c.txt", test2c, 15, 7},
		{"test2d.txt", test2d, 11, 9},
		{"test2e.txt", test2e, 13, 1},
		{"test2f.txt", test2f, 19, 0},
		{"test2g.txt", test2g, 16, 0},
		{"test2h.txt", test2h, 20, 1},
		// {"input.txt", input, 951, 902198718880},
	}
	for _, tc := range tests {
		t.Run(tc.file, func (t *testing.T) {
			pkt := NewPacketHex(tc.data)
			p1, p2 := pkt.Parts()
			assert.Equal(t, tc.p1, p1, tc.file)
			assert.Equal(t, tc.p2, p2, tc.file)
		})
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
