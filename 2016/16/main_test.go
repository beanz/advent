package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestDragon(t *testing.T) {
	assert.Equal(t, "100", Dragon("1", 3))
	assert.Equal(t, "001", Dragon("0", 3))
	assert.Equal(t, "11111000000", Dragon("11111", 11))
	assert.Equal(t, "1111000010100101011110000", Dragon("111100001010", 25))
}

func TestChecksum(t *testing.T) {
	assert.Equal(t, "100", Checksum("110010110100"))
	assert.Equal(t, "01100", Checksum("10000011110010000111"))
}

func TestDiscData(t *testing.T) {
	game := Game{"10000", 20, false}
	assert.Equal(t, "10000011110010000111", game.DiscData())
}

func TestPlay(t *testing.T) {
	game := Game{"10000", 20, false}
	assert.Equal(t, "01100", game.Play())
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
