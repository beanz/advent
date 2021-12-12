package aoc

import (
	"log"
)

// See: https://www.redblobgames.com/grids/hexagons/

type HexPoint struct {
	q, r int
}

func NewHexPoint(q, r int) *HexPoint {
	return &HexPoint{q, r}
}

func (h *HexPoint) Q() int {
	return h.q
}

func (h *HexPoint) R() int {
	return h.r
}

func (h *HexPoint) X() int {
	return h.q
}

func (h *HexPoint) Y() int {
	return -h.q - h.r
}
func (h *HexPoint) Z() int {
	return h.r
}

func (h *HexPoint) Neighbours() []*HexPoint {
	return []*HexPoint{
		&HexPoint{h.q + 1, h.r + 0},
		&HexPoint{h.q + 1, h.r - 1},
		&HexPoint{h.q + 0, h.r - 1},
		&HexPoint{h.q - 1, h.r + 0},
		&HexPoint{h.q - 1, h.r + 1},
		&HexPoint{h.q - 0, h.r + 1},
	}
}

func (h *HexPoint) Move(dir string) {
	switch dir {
	case "n":
		h.r--
	case "s":
		h.r++
	case "nw":
		h.q--
	case "se":
		h.q++
	case "ne":
		h.q++
		h.r--
	case "sw":
		h.q--
		h.r++
	default:
		log.Fatalf("Invalid hex direction %s\n", dir)
	}
}

func (h1 *HexPoint) Distance(h2 *HexPoint) int {
	return (Abs(h1.q-h2.q) + Abs(h1.q+h1.r-h2.q-h2.r) + Abs(h1.r-h2.r)) / 2
}
