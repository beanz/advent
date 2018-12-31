package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestTwist(t *testing.T) {
	r := NewRope("test.txt", 5)
	assert.Equal(t, "[0] 1 2 3 4", r.String())
	r.Twist(3)
	assert.Equal(t, "2 1 0 [3] 4", r.String())
	r.Twist(4)
	assert.Equal(t, "4 3 0 [1] 2", r.String())
	r.Twist(1)
	assert.Equal(t, "4 [3] 0 1 2", r.String())
}

func TestPart1(t *testing.T) {
	assert.Equal(t, 12, NewRope("test.txt", 5).Part1())
	assert.Equal(t, 23715, NewRope("input.txt", 256).Part1())
}

func TestPart2(t *testing.T) {
	assert.Equal(t, "a2582a3a0e66e6e86e3812dcb672a272",
		NewPart2Rope("test-2a.txt", 256).Part2())
	assert.Equal(t, "33efeb34ea91902bb2f59c9920caa6cd",
		NewPart2Rope("test-2b.txt", 256).Part2())
	assert.Equal(t, "3efbe78a8d82f29979031a4aa0b16a9d",
		NewPart2Rope("test-2c.txt", 256).Part2())
	assert.Equal(t, "63960835bcdc130f0b66d7ff4f6a5a8e",
		NewPart2Rope("test-2d.txt", 256).Part2())
	assert.Equal(t, "541dc3180fd4b72881e39cf925a50253",
		NewPart2Rope("input.txt", 256).Part2())
}
