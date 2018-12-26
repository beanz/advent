package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestTriple(t *testing.T) {
	assert.Equal(t, "8", Triple("0034e0923cc38887a57bd7b1d4f953df"))
}

func TestMD5(t *testing.T) {
	game := Game{"abc", 0, map[int]string{}, false, false}
	assert.Equal(t, "0034e0923cc38887a57bd7b1d4f953df", game.MD5(18))
}

func TestStretchedMD5(t *testing.T) {
	game := Game{"abc", 0, map[int]string{}, true, false}
	assert.Equal(t, "a107ff634856bb300138cac6568c0f24", game.MD5(0))
}
