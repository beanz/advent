package main

import (
	_ "embed"
	"github.com/stretchr/testify/assert"
	"testing"
)

//go:embed test.txt
var test []byte

func TestPlay(t *testing.T) {
	best, longest := NewGame(test).Play()
	assert.Equal(t, uint16(31), best)
	assert.Equal(t, uint16(19), longest)
	best, longest = NewGame(input).Play()
	assert.Equal(t, uint16(1940), best)
	assert.Equal(t, uint16(1928), longest)
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
