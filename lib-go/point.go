package aoc

import (
	"fmt"
	"math"
)

// Point is a two dimensional point defined by x and y coordinates
type Point struct {
	X, Y int
}

func (p Point) String() string {
	return fmt.Sprintf("%d,%d", p.X, p.Y)
}

func (p *Point) In(d Direction) Point {
	return Point{p.X + d.Dx, p.Y + d.Dy}
}

// Neighbours returns the four neighbours of a point
func (p Point) Neighbours() []Point {
	n := []Point{}
	n = append(n, Point{p.X, p.Y - 1})
	n = append(n, Point{p.X - 1, p.Y})
	n = append(n, Point{p.X + 1, p.Y})
	n = append(n, Point{p.X, p.Y + 1})
	return n
}

// Neighbours8 returns the eight neighbours of a point
func (p Point) Neighbours8() []Point {
	n := []Point{}
	n = append(n, Point{p.X - 1, p.Y - 1})
	n = append(n, Point{p.X + 0, p.Y - 1})
	n = append(n, Point{p.X + 1, p.Y - 1})
	n = append(n, Point{p.X - 1, p.Y + 0})
	n = append(n, Point{p.X + 1, p.Y + 0})
	n = append(n, Point{p.X - 1, p.Y + 1})
	n = append(n, Point{p.X + 0, p.Y + 1})
	n = append(n, Point{p.X + 1, p.Y + 1})
	return n
}

func Abs(x int) int {
	if x < 0 {
		return -x
	}
	return x
}

// ManhattanDistance returns the Manhattan distance between a 2d point
// and another 2d point
func (p Point) ManhattanDistance(o Point) int {
	return Abs(p.X-o.X) + Abs(p.Y-o.Y)
}

func (p Point) Size() float64 {
	return math.Sqrt(float64(p.X)*float64(p.X) + float64(p.Y)*float64(p.Y))
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
