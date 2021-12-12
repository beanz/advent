package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestCollisionDetction(t *testing.T) {
	p1 := &Particle{Point3D{-6, 0, 0}, Point3D{3, 0, 0}, Point3D{0, 0, 0},
		false}
	p2 := &Particle{Point3D{-4, 0, 0}, Point3D{2, 0, 0}, Point3D{0, 0, 0},
		false}
	p3 := &Particle{Point3D{3, 0, 0}, Point3D{-1, 0, 0}, Point3D{0, 0, 0},
		false}
	assert.False(t, p1.Collision(p2, 0), "p1&p2 t=0")
	assert.False(t, p1.Collision(p2, 1), "p1&p2 t=1")
	assert.True(t, p1.Collision(p2, 2), "p1&p2 t=2")
	assert.False(t, p1.Collision(p3, 0), "p1&p3 t=0")
	assert.False(t, p1.Collision(p3, 1), "p1&p3 t=1")
	assert.False(t, p1.Collision(p3, 2), "p1&p3 t=2")
	bp1 := &Particle{Point3D{1209, 168, -645}, Point3D{-85, 39, 108},
		Point3D{-7, -9, -9}, false}
	bp2 := &Particle{Point3D{339, -537, -720}, Point3D{-97, 5, 66},
		Point3D{11, 10, 0}, false}
	assert.True(t, bp1.Collision(bp2, 10), "bp1 & bp2")
}

func TestPart1(t *testing.T) {
	assert.Equal(t, 0, NewGame(ReadLines("test.txt")).Part1())
	assert.Equal(t, 91, NewGame(ReadLines("input.txt")).Part1())
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 1, NewGame(ReadLines("test-2.txt")).Part2())
	assert.Equal(t, 0, NewGame(ReadLines("test-2a.txt")).Part2())
	assert.Equal(t, 567, NewGame(ReadLines("input.txt")).Part2())
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
