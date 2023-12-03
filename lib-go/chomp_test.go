package aoc

import (
	"testing"

	assert "github.com/stretchr/testify/require"
)

func Test_ChompUInt(t *testing.T) {
	i, n := ChompUInt[int]([]byte("foo 123\n"), 4)
	assert.Equal(t, i, 7)
	assert.Equal(t, n, 123)
	assert.Panics(t, func() {
		ChompUInt[int]([]byte("foo"), 0)
	})
}

func Test_ChompInt(t *testing.T) {
	i, n := ChompInt[int]([]byte("foo 123\n"), 4)
	assert.Equal(t, i, 7)
	assert.Equal(t, n, 123)
	i, n = ChompInt[int]([]byte("foo -123\n"), 4)
	assert.Equal(t, i, 8)
	assert.Equal(t, n, -123)
	assert.Panics(t, func() {
		ChompUInt[int]([]byte("foo"), 0)
	})
}

func Test_ChompToNextLine(t *testing.T) {
	in := []byte("1\nthis is a test of the chomp to next line\n012345\n")
	i := ChompToNextLine(in, 3)
	assert.Equal(t, i, 43)
	assert.Equal(t, ChompToNextLine(in, 43), 50)
}

func Benchmark_ChompToNextLine(b *testing.B) {
	in := []byte("1\nthis is a test of the chomp to next line\n012345\n")
	for i := 0; i < b.N; i++ {
		i := ChompToNextLine(in, 3)
		j := ChompToNextLine(in, i)
		if j != 50 {
			panic("error")
		}
	}
}

func Test_ChompOneOrTwoCharUInt(t *testing.T) {
	b := []byte("foo 1 2 3 4 12 13 14 15")
	i, n := ChompUInt[int](b, 4)
	assert.Equal(t, i, 5)
	assert.Equal(t, n, 1)
	i, n = ChompUInt[int](b, i+1)
	assert.Equal(t, n, 2)
	i, n = ChompUInt[int](b, i+1)
	assert.Equal(t, n, 3)
	i, n = ChompUInt[int](b, i+1)
	assert.Equal(t, n, 4)
	i, n = ChompUInt[int](b, i+1)
	assert.Equal(t, n, 12)
	i, n = ChompUInt[int](b, i+1)
	assert.Equal(t, n, 13)
	i, n = ChompUInt[int](b, i+1)
	assert.Equal(t, i, 20)
	assert.Equal(t, n, 14)
	assert.Panics(t, func() {
		ChompOneOrTwoCharUInt[int]([]byte("foo"), 0)
	})
}

func Benchmark_ChompOneOrTwoCharUInt(b *testing.B) {
	in := []byte("foo 1 2 3 4 12 13 14 15")
	for i := 0; i < b.N; i++ {
		j, _ := ChompUInt[int](in, 4)
		j, _ = ChompUInt[int](in, j+1)
		j, _ = ChompUInt[int](in, j+1)
		j, _ = ChompUInt[int](in, j+1)
		j, _ = ChompUInt[int](in, j+1)
		j, _ = ChompUInt[int](in, j+1)
		_, _ = ChompUInt[int](in, j+1)
	}
}
