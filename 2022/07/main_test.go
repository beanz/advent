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
	// Part 1: 1432936
	// Part 2: 272298
}

func TestParts(t *testing.T) {
	tests := []struct {
		file   string
		data   []byte
		p1, p2 int
	}{
		{"test1.txt", test1, 95437, 24933642},
		{"input.txt", input, 1432936, 272298},
	}
	for _, tc := range tests {
		p1, p2 := Parts(tc.data)
		assert.Equal(t, tc.p1, p1, tc.file)
		assert.Equal(t, tc.p2, p2, tc.file)
	}
}

func Test_bparent(t *testing.T) {
	assert.Equal(t, []byte{'/'}, bparent([]byte("/a")))
	assert.Equal(t, []byte("/a"), bparent([]byte("/a/b")))
	assert.Equal(t, []byte{'/'}, bparent([]byte("/")))
}

func Test_bcd(t *testing.T) {
	assert.Equal(t, []byte{'/'}, bcd([]byte("/a/b"), []byte{'/'}))
	assert.Equal(t, []byte("/a"), bcd([]byte("/a/b"), []byte("..")))
	assert.Equal(t, []byte("/a/b"), bcd([]byte("/a"), []byte("b")))
}

func Test_parent(t *testing.T) {
	assert.Equal(t, "/", parent("/a"))
	assert.Equal(t, "/a", parent("/a/b"))
	assert.Equal(t, "/", parent("/"))
}

func Test_cd(t *testing.T) {
	assert.Equal(t, "/", cd("/a/b", "/"))
	assert.Equal(t, "/a", cd("/a/b", ".."))
	assert.Equal(t, "/a/b", cd("/a", "b"))
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
