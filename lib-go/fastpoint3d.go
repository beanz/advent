package aoc

import (
	"fmt"
)

type FP3 uint64

func NewFP3(x, y, z int16) FP3 {
	return FP3(uint64(uint16(x))<<32 +
		uint64(uint16(y))<<16 +
		uint64(uint16(z)))
}

func (p FP3) String() string {
	x, y, z := p.XYZ()
	return fmt.Sprintf("%d,%d,%d", x, y, z)
}

func (p FP3) XYZ() (int16, int16, int16) {
	z := int16(p & 0xffff)
	y := int16((p >> 16) & 0xffff)
	x := int16((p >> 32) & 0xffff)
	return x, y, z
}

func (p FP3) ManhattanDistance(o FP3) int {
	z := int16(p & 0xffff)
	y := int16((p >> 16) & 0xffff)
	x := int16((p >> 32) & 0xffff)
	oz := int16(o & 0xffff)
	oy := int16((o >> 16) & 0xffff)
	ox := int16((o >> 32) & 0xffff)
	var dx int16
	if x > ox {
		dx = x - ox
	} else {
		dx = ox - x
	}
	var dy int16
	if y > oy {
		dy = y - oy
	} else {
		dy = oy - y
	}
	var dz int16
	if z > oz {
		dz = z - oz
	} else {
		dz = oz - z
	}
	return int(dx) + int(dy) + int(dz)
}

func (p FP3) Add(o FP3) FP3 {
	z := int16(p & 0xffff)
	y := int16((p >> 16) & 0xffff)
	x := int16((p >> 32) & 0xffff)
	oz := int16(o & 0xffff)
	oy := int16((o >> 16) & 0xffff)
	ox := int16((o >> 32) & 0xffff)
	return NewFP3(x+ox, y+oy, z+oz)
}

func (p FP3) Sub(o FP3) FP3 {
	z := int16(p & 0xffff)
	y := int16((p >> 16) & 0xffff)
	x := int16((p >> 32) & 0xffff)
	oz := int16(o & 0xffff)
	oy := int16((o >> 16) & 0xffff)
	ox := int16((o >> 32) & 0xffff)
	return NewFP3(x-ox, y-oy, z-oz)
}

func (p FP3) Norm(o FP3) FP3 {
	z := int16(p & 0xffff)
	y := int16((p >> 16) & 0xffff)
	x := int16((p >> 32) & 0xffff)
	var nx int16
	var ny int16
	var nz int16
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
	if z > 0 {
		nz = 1
	} else if z < 0 {
		nz = -1
	}
	return NewFP3(nx, ny, nz)
}

func (p FP3) Rotate(rotation int) FP3 {
	z := int16(p & 0xffff)
	y := int16((p >> 16) & 0xffff)
	x := int16((p >> 32) & 0xffff)
	switch rotation {
	case 0:
		return NewFP3(x, y, z)
	case 1:
		return NewFP3(x, z, -y)
	case 2:
		return NewFP3(x, -y, -z)
	case 3:
		return NewFP3(x, -z, y)
	case 4:
		return NewFP3(y, -x, z)
	case 5:
		return NewFP3(y, z, x)
	case 6:
		return NewFP3(y, x, -z)
	case 7:
		return NewFP3(y, -z, -x)
	case 8:
		return NewFP3(-x, -y, z)
	case 9:
		return NewFP3(-x, -z, -y)
	case 10:
		return NewFP3(-x, y, -z)
	case 11:
		return NewFP3(-x, z, y)
	case 12:
		return NewFP3(-y, x, z)
	case 13:
		return NewFP3(-y, -z, x)
	case 14:
		return NewFP3(-y, -x, -z)
	case 15:
		return NewFP3(-y, z, -x)
	case 16:
		return NewFP3(z, y, -x)
	case 17:
		return NewFP3(z, x, y)
	case 18:
		return NewFP3(z, -y, x)
	case 19:
		return NewFP3(z, -x, -y)
	case 20:
		return NewFP3(-z, -y, -x)
	case 21:
		return NewFP3(-z, -x, y)
	case 22:
		return NewFP3(-z, y, x)
	case 23:
		return NewFP3(-z, x, -y)
	default:
		panic("invalid rotation")
	}
}
