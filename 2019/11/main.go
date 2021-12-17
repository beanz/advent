package main

import (
	_ "embed"
	"fmt"

	"github.com/beanz/advent/lib-go/intcode"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Hull struct {
	pos Point
	dir Direction
	m   map[Point]bool
	bb  *BoundingBox
}

func NewHull() *Hull {
	return &Hull{Point{0, 0}, Direction{0, -1},
		make(map[Point]bool), NewBoundingBox()}
}

func (h *Hull) input() int64 {
	if v, ok := h.m[h.pos]; !ok || !v {
		return 0
	}
	return 1
}

func (h *Hull) output(val int64) {
	h.m[h.pos] = val == 1
}

func (h *Hull) processOutput(col, turn int64) {
	h.output(col)
	if turn == 1 {
		h.dir = h.dir.CW()
	} else {
		h.dir = h.dir.CCW()
	}
	h.pos = h.pos.In(h.dir)
	h.bb.Add(h.pos)
}

func run(p []int64, input int64) *Hull {
	h := NewHull()
	ic := intcode.NewIntCode(p, []int64{input})
	for !ic.Done() {
		ic.Run()
		o := ic.Out(2)
		if len(o) == 2 {
			h.processOutput(o[0], o[1])
			ic.In(h.input())
		}
	}
	return h
}

func part1(p []int64) int {
	h := run(p, 0)
	return len(h.m)
}

func part2(p []int64) string {
	h := run(p, 1)
	s := ""
	for y := h.bb.Min.Y; y <= h.bb.Max.Y; y++ {
		for x := h.bb.Min.X; x <= h.bb.Max.X; x++ {
			if v, ok := h.m[Point{x, y}]; ok && v {
				s += "#"
			} else {
				s += "."
			}
		}
		s += "\n"
	}
	return s
}

func main() {
	p := FastInt64s(InputBytes(input), 4096)
	p1 := part1(p)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p = FastInt64s(InputBytes(input), 4096)
	p2 := part2(p)
	if !benchmark {
		fmt.Printf("Part 2:\n%s", p2)
	}
}

var benchmark = false
