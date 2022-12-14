package aoc

import (
	"fmt"
	"math"
)

type FBoundingBox struct {
	xmin, xmax, ymin, ymax int32
}

func NewFBoundingBox() *FBoundingBox {
	return &FBoundingBox{math.MaxInt32, math.MinInt32,
		math.MaxInt32, math.MinInt32}
}

func (bb *FBoundingBox) String() string {
	return fmt.Sprintf("[%d < %d, %d < %d]",
		bb.xmin, bb.xmax, bb.ymin, bb.ymax)
}

func (bb *FBoundingBox) Limits() (int32, int32, int32, int32) {
	return bb.xmin, bb.xmax, bb.ymin, bb.ymax
}

func (bb *FBoundingBox) XLimits() (int32, int32) {
	return bb.xmin, bb.xmax
}

func (bb *FBoundingBox) YLimits() (int32, int32) {
	return bb.ymin, bb.ymax
}

func (bb *FBoundingBox) Add(p FP2) {
	x, y := p.XY()
	bb.AddXY(x, y)
}

func (bb *FBoundingBox) AddXY(x, y int32) {
	if x > bb.xmax {
		bb.xmax = x
	}
	if x < bb.xmin {
		bb.xmin = x
	}
	if y > bb.ymax {
		bb.ymax = y
	}
	if y < bb.ymin {
		bb.ymin = y
	}
}
