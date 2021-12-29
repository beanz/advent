package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
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

func TestMD5(t *testing.T) {
	game := NewGame([]byte("abc"), false)
	assert.Equal(t, "0034e0923cc38887a57bd7b1d4f953df", game.ring[18])
}

func TestStretchedMD5(t *testing.T) {
	game := NewGame([]byte("abc"), true)
	assert.Equal(t, "a107ff634856bb300138cac6568c0f24", game.ring[0])
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
