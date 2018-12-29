package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestPlayMarbles(t *testing.T) {
	assert.Equal(t, 32, playMarbles(9, 25))
	assert.Equal(t, 8317, playMarbles(10, 1618))
	assert.Equal(t, 146373, playMarbles(13, 7999))
	assert.Equal(t, 2764, playMarbles(17, 1104))
	assert.Equal(t, 54718, playMarbles(21, 6111))
	assert.Equal(t, 37305, playMarbles(30, 5807))
}

func TestPlayMarblesFaster(t *testing.T) {
	assert.Equal(t, 32, playMarblesFaster(9, 25))
	assert.Equal(t, 8317, playMarblesFaster(10, 1618))
	assert.Equal(t, 146373, playMarblesFaster(13, 7999))
	assert.Equal(t, 2764, playMarblesFaster(17, 1104))
	assert.Equal(t, 54718, playMarblesFaster(21, 6111))
	assert.Equal(t, 37305, playMarblesFaster(30, 5807))
	assert.Equal(t, 385820, playMarblesFaster(468, 71843))
	assert.Equal(t, 3156297594, playMarblesFaster(468, 7184300))
}
