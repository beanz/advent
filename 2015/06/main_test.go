package main

import (
	"testing"

	"github.com/stretchr/testify/assert"

	. "github.com/beanz/advent/lib-go"
)

func TestParts(t *testing.T) {
	in := ReadFileLines("input.txt")
	p1, p2 := calc(in)
	assert.Equal(t, 400410, p1)
	assert.Equal(t, 15343601, p2)
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
