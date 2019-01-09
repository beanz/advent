package aoc

import (
	"fmt"
	"math"
)

// BoundingBox is a 2D bounding box representing by min and max points
type BoundingBox struct {
	Min Point
	Max Point
}

func (bb *BoundingBox) String() string {
	return fmt.Sprintf("[%d < %d, %d < %d]",
		bb.Min.X, bb.Max.X, bb.Min.Y, bb.Max.Y)
}

func NewBoundingBox() *BoundingBox {
	return &BoundingBox{
		Point{math.MaxInt64, math.MaxInt64},
		Point{math.MinInt64, math.MinInt64},
	}
}

func (bb *BoundingBox) Add(p Point) {
	if p.X > bb.Max.X {
		bb.Max.X = p.X
	}
	if p.X < bb.Min.X {
		bb.Min.X = p.X
	}
	if p.Y > bb.Max.Y {
		bb.Max.Y = p.Y
	}
	if p.Y < bb.Min.Y {
		bb.Min.Y = p.Y
	}
}

func (bb *BoundingBox) Contains(p Point) bool {
	if p.X > bb.Max.X {
		return false
	}
	if p.X < bb.Min.X {
		return false
	}
	if p.Y > bb.Max.Y {
		return false
	}
	if p.Y < bb.Min.Y {
		return false
	}
	return true
}
