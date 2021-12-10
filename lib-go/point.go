package aoc

import (
	"fmt"
	"math"
)

// Point is a two dimensional point defined by x and y coordinates
type Point struct {
	X, Y int
}

var EightNeighbourOffsets = []Point{
	Point{X: -1, Y: -1}, Point{X: 0, Y: -1}, Point{X: 1, Y: -1},
	Point{X: -1, Y: 0} /*                */, Point{X: 1, Y: 0},
	Point{X: -1, Y: 1}, Point{X: 0, Y: 1}, Point{X: 1, Y: 1},
}

var FourNeighbourOffsets = []Point{
	Point{X: 0, Y: -1},
	Point{X: -1, Y: 0}, Point{X: 1, Y: 0},
	Point{X: 0, Y: 1},
}

func (p Point) String() string {
	return fmt.Sprintf("%d,%d", p.X, p.Y)
}

func (p *Point) In(d Direction) Point {
	return Point{p.X + d.Dx, p.Y + d.Dy}
}

// Neighbours returns the four neighbours of a point
func (p Point) Neighbours() []Point {
	return []Point{
		Point{p.X, p.Y - 1},
		Point{p.X - 1, p.Y},
		Point{p.X + 1, p.Y},
		Point{p.X, p.Y + 1}}
}

// Neighbours8 returns the eight neighbours of a point
func (p Point) Neighbours8() []Point {
	return []Point{
		Point{p.X - 1, p.Y - 1},
		Point{p.X + 0, p.Y - 1},
		Point{p.X + 1, p.Y - 1},
		Point{p.X - 1, p.Y + 0},
		Point{p.X + 1, p.Y + 0},
		Point{p.X - 1, p.Y + 1},
		Point{p.X + 0, p.Y + 1},
		Point{p.X + 1, p.Y + 1},
	}
}

// ManhattanDistance returns the Manhattan distance between a 2d point
// and another 2d point
func (p Point) ManhattanDistance(o Point) int {
	return Abs(p.X-o.X) + Abs(p.Y-o.Y)
}

func (p Point) Size() float64 {
	return math.Sqrt(float64(p.X)*float64(p.X) + float64(p.Y)*float64(p.Y))
}

func (p *Point) Norm(o *Point) *Point {
	r := Point{0,0}
	if p.X > o.X {
		r.X = -1
	} else if p.X < o.X {
		r.X = 1
	}
	if p.Y > o.Y {
		r.Y = -1
	} else if p.Y < o.Y {
		r.Y = 1
	}
	return &r
}

type Point3D struct {
	X, Y, Z int
}

func (p Point3D) String() string {
	return fmt.Sprintf("%d,%d,%d", p.X, p.Y, p.Z)
}

func (p Point3D) ManhattanDistance(o Point3D) int {
	return Abs(p.X-o.X) + Abs(p.Y-o.Y) + Abs(p.Z-o.Z)
}

func (p Point3D) Size() float64 {
	return math.Sqrt(float64(p.X)*float64(p.X) +
		float64(p.Y)*float64(p.Y) + float64(p.Z)*float64(p.Z))
}

type PointPair struct {
	P1 *Point
	P2 *Point
}

func (pp* PointPair) String() string {
	return fmt.Sprintf("%s -> %s\n", pp.P1, pp.P2)
}

func (pp* PointPair) Norm() *Point {
	return pp.P1.Norm(pp.P2)
}
