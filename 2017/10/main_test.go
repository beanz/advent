package main

import (
	_ "embed"
	. "github.com/beanz/advent/lib-go"
	assert "github.com/stretchr/testify/require"
	"testing"
)

//go:embed test.txt
var test1 []byte

func TestTwist(t *testing.T) {
	r := NewRope(InputLines(test1)[0], 5)
	assert.Equal(t, "[0] 1 2 3 4", r.String(), "init")
	r.Twist(3)
	assert.Equal(t, "2 1 0 [3] 4", r.String(), "twist 3")
	r.Twist(4)
	assert.Equal(t, "4 3 0 [1] 2", r.String(), "twist 4")
	r.Twist(1)
	assert.Equal(t, "4 [3] 0 1 2", r.String(), "twist 1")
}

func TestPart1(t *testing.T) {
	assert.Equal(t, 12, NewRope(InputLines(test1)[0], 5).Part1())
	assert.Equal(t, 23715, NewRope(InputLines(input)[0], 256).Part1())
}

//go:embed test-2a.txt
var test2a []byte

//go:embed test-2b.txt
var test2b []byte

//go:embed test-2c.txt
var test2c []byte

//go:embed test-2d.txt
var test2d []byte

func TestPart2(t *testing.T) {
	assert.Equal(t, "a2582a3a0e66e6e86e3812dcb672a272",
		NewPart2Rope(InputLines(test2a)[0], 256).Part2())
	assert.Equal(t, "33efeb34ea91902bb2f59c9920caa6cd",
		NewPart2Rope(InputLines(test2b)[0], 256).Part2())
	assert.Equal(t, "3efbe78a8d82f29979031a4aa0b16a9d",
		NewPart2Rope(InputLines(test2c)[0], 256).Part2())
	assert.Equal(t, "63960835bcdc130f0b66d7ff4f6a5a8e",
		NewPart2Rope(InputLines(test2d)[0], 256).Part2())
	assert.Equal(t, "541dc3180fd4b72881e39cf925a50253",
		NewPart2Rope(InputLines(input)[0], 256).Part2())
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
