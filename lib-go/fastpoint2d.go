package aoc

import (
	"fmt"
)

type FP2 uint64

func NewFP2(x, y int32) FP2 {
	return FP2(uint64(uint32(x))<<32 + uint64(uint32(y)))
}

func (p FP2) String() string {
	x, y := p.XY()
	return fmt.Sprintf("%d,%d", x, y)
}

func (p FP2) XY() (int32, int32) {
	y := int32(p & 0xffffffff)
	x := int32((p >> 32) & 0xffffffff)
	return x, y
}

func FP2UKeyMax(bits int) int {
	return 2 << (bits * 2)
}

func (p FP2) UKey(bits int) uint64 {
	y := p & 0xffffffff
	x := (p >> 32) & 0xffffffff
	return uint64(x<<bits + y)
}

func (p FP2) ManhattanDistance(o FP2) int {
	y := int32(p & 0xffffffff)
	x := int32((p >> 32) & 0xffffffff)
	oy := int32(o & 0xffffffff)
	ox := int32((o >> 32) & 0xffffffff)
	var dx int
	if x > ox {
		dx = int(x - ox)
	} else {
		dx = int(ox - x)
	}
	var dy int
	if y > oy {
		dy = int(y - oy)
	} else {
		dy = int(oy - y)
	}
	return dx + dy
}

func (p FP2) Add(o FP2) FP2 {
	y := int32(p & 0xffffffff)
	x := int32((p >> 32) & 0xffffffff)
	oy := int32(o & 0xffffffff)
	ox := int32((o >> 32) & 0xffffffff)
	return NewFP2(x+ox, y+oy)
}

func (p FP2) Sub(o FP2) FP2 {
	y := int32(p & 0xffffffff)
	x := int32((p >> 32) & 0xffffffff)
	oy := int32(o & 0xffffffff)
	ox := int32((o >> 32) & 0xffffffff)
	return NewFP2(x-ox, y-oy)
}

func (p FP2) Norm(o FP2) FP2 {
	y := int32(p & 0xffffffff)
	x := int32((p >> 32) & 0xffffffff)
	var nx int32
	var ny int32
	if x > 0 {
		nx = 1
	} else if x < 0 {
		nx = -1
	}
	if y > 0 {
		ny = 1
	} else if y < 0 {
		ny = -1
	}
	return NewFP2(nx, ny)
}

func (p FP2) Rotate(rotation int) FP2 {
	y := int32(p & 0xffffffff)
	x := int32((p >> 32) & 0xffffffff)
	switch rotation {
	case 0:
		return NewFP2(x, y)
	case 1:
		return NewFP2(x, -y)
	case 2:
		return NewFP2(y, -x)
	case 3:
		return NewFP2(y, x)
	case 4:
		return NewFP2(-x, -y)
	case 5:
		return NewFP2(-x, y)
	case 6:
		return NewFP2(-y, x)
	case 7:
		return NewFP2(-y, -x)
	default:
		panic("invalid rotation")
	}
}

func (p FP2) CW() FP2 {
	x, y := p.XY()
	return NewFP2(-y, x)
}

func (p FP2) CCW() FP2 {
	x, y := p.XY()
	return NewFP2(y, -x)
}
