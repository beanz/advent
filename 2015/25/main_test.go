package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestSumSeries(t *testing.T) {
	assert.Equal(t, 55, SumSeries(1, 10), "sum series 1 .. 10")
	assert.Equal(t, 52, SumSeries(3, 10), "sum series 3 .. 10")
}

func TestPosIndex(t *testing.T) {
	assert.Equal(t, 1, PosIndex(1, 1), "pos index 1, 1")
	assert.Equal(t, 2, PosIndex(2, 1), "pos index 2, 1")
	assert.Equal(t, 3, PosIndex(1, 2), "pos index 1, 2")
	assert.Equal(t, 12, PosIndex(4, 2), "pos index 4, 2")
	assert.Equal(t, 21, PosIndex(1, 6), "pos index 1, 6")
	assert.Equal(t, 14, PosIndex(2, 4), "pos index 2, 4")
	assert.Equal(t, 17850354, PosIndex(2947, 3029), "pos index 2947, 3029")
}

func TestSeq(t *testing.T) {
	assert.Equal(t, 20151125, Seq(1), "sequence 1")
	assert.Equal(t, 31916031, Seq(2), "sequence 2")
	assert.Equal(t, 18749137, Seq(3), "sequence 3")
	assert.Equal(t, 7726640, Seq(14), "sequence 14")
}

func TestInput(t *testing.T) {
	assert.Equal(t, 19980801, calc(ReadFileInts("input.txt")),
		"Part 1 on input.txt")
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
