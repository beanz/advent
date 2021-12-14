package main

import (
	_ "embed"
	assert "github.com/stretchr/testify/require"
	"testing"
)

//go:embed test1.txt
var test1 []byte

//go:embed test2.txt
var test2 []byte

//go:embed input.txt
var safeinput []byte

func TestNetIsTLS(t *testing.T) {
	tests := []struct {
		ip  string
		ans bool
	}{
		{"abba[mnop]qrst", true},
		{"abcd[bddb]xyyx", false},
		{"aaaa[qwer]tyui", false},
		{"ioxxoj[asdfgh]zxcvbn", true},
	}
	for _, tc := range tests {
		ip := NewIP([]byte(tc.ip))
		assert.Equal(t, tc.ans, ip.IsTLS(), tc.ip)
	}
}

func TestNetIsSSL(t *testing.T) {
	tests := []struct {
		ip  string
		ans bool
	}{
		{"aba[bab]xyz", true},
		{"xyx[xyx]xyx", false},
		{"aaa[kek]eke", true},
		{"zazbz[bzb]cdb", true},
	}
	for _, tc := range tests {
		ip := NewIP([]byte(tc.ip))
		assert.Equal(t, tc.ans, ip.IsSSL(), tc.ip)
	}
}

type TestCase struct {
	file   string
	data   []byte
	p1, p2 int
}

func TestParts(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", test1, 2, 0},
		{"test2.txt", test2, 0, 3},
		{"input.txt", input, 115, 231},
	}
	for _, tc := range tests {
		p1, p2 := NewNet(tc.data).Parts()
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
