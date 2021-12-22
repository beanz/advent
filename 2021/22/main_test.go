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

//go:embed test3.txt
var test3 []byte

//go:embed input.txt
var safeinput []byte

func ExampleMain() {
	main()
	//Output:
	// Part 1: 598616
	// Part 2: 1193043154475246
}

func TestReboot(t *testing.T) {
	tests := []struct {
		file   string
		data   []byte
		p1, p2 int
	}{
		{"test1.txt", test1, 39, 39},
		{"test2.txt", test2, 590784, 39769202357779},
		{"test3.txt", test3, 474140, 2758514936282235},
		{"input.txt", input, 598616, 1193043154475246},
	}
	for _, tc := range tests {
		p1, p2 := NewReactor(tc.data).Reboot()
		assert.Equal(t, tc.p1, p1, "1: "+tc.file)
		assert.Equal(t, tc.p2, p2, "2: "+tc.file)
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
