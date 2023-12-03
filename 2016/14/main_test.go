package main

import (
	"crypto/md5"
	"fmt"
	"testing"

	"github.com/stretchr/testify/assert"
)

func ExampleMain() {
	main()
	//Output:
	// Part 1: 23769
	// Part 2: 20606
}

func TestTriple(t *testing.T) {
	assert.Equal(t, "8", Triple("0034e0923cc38887a57bd7b1d4f953df"))
}

func TestTripleDigit(t *testing.T) {
	game := NewGame([]byte("abc"), false)
	d, found := TripleDigit(game.ring[18][:16])
	assert.True(t, found)
	assert.Equal(t, byte(8), d)
	d, found = TripleDigit(game.ring[39][:16])
	assert.True(t, found)
	assert.Equal(t, byte(14), d)
}

func TestHasFive(t *testing.T) {
	game := NewGame([]byte("abc"), false)
	assert.True(t, HasFive(game.ring[816][:16], 0xe))
}

func TestMD5(t *testing.T) {
	game := NewGame([]byte("abc"), false)
	assert.Equal(t, "0034e0923cc38887a57bd7b1d4f953df", fmt.Sprintf("%x", game.ring[18]))
}

func TestIntToHex(t *testing.T) {
	sum := md5.Sum([]byte("abc0"))
	b := make([]byte, 32)
	for j := 0; j < 16; j++ {
		b[j*2] = IntToHex((sum[j] & 0xf0) >> 4)
		b[1+j*2] = IntToHex(sum[j] & 0xf)
	}
	assert.Equal(t, fmt.Sprintf("%x", sum), string(b))
}

func TestStretchedMD5(t *testing.T) {
	game := NewGame([]byte("abc"), true)
	assert.Equal(t, "a107ff634856bb300138cac6568c0f24",
		fmt.Sprintf("%x", game.ring[0]))
}

func TestNext(t *testing.T) {
	g := NewGame([]byte("abc"), false)
	assert.Equal(t, 39, g.NextKey(), "first key for abc part 1")
	assert.Equal(t, 92, g.NextKey(), "second key for abc part 1")
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
