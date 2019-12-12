package aoc

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestGCD(t *testing.T) {
	assert.Equal(t, int64(6), GCD(54, 24))
	assert.Equal(t, int64(1), GCD(-2, -7))
}
