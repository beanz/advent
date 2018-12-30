package aoc

import "fmt"

// BoundingBox is a 2D bounding box representing by min and max points
type BoundingBox struct {
	Min Point
	Max Point
}

func (bb BoundingBox) String() string {
	return fmt.Sprintf("[%d < %d, %d < %d]",
		bb.Min.X, bb.Max.X, bb.Min.Y, bb.Max.Y)
}
