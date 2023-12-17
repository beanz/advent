package main

import (
	"container/heap"
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Solve(m *ByteMap, minD, maxD int16) int {
	w, h := m.Width(), m.Height()
	tx, ty := int16(w-1), int16(h-1)
	pq := make(PQ, 0, 10240)
	if minD == 0 {
		pq = append(pq, &Rec{x: 0, y: 0, d: RIGHT, loss: 0})
	}
	heap.Init(&pq)
	seen := [80000]bool{}
	add := func(x, y int16, d Dir, loss int16) {
		for s := int16(1); s <= maxD; s++ {
			x += d.X()
			y += d.Y()
			if x < 0 || x > tx || y < 0 || y > ty {
				return
			}
			loss += int16(m.GetXY(int(x), int(y)) - '0')
			if s < minD {
				continue
			}

			nr := &Rec{x: x, y: y, d: d, loss: loss}
			heap.Push(&pq, nr)
		}
	}
	add(0, 0, RIGHT, 0)
	for pq.Len() > 0 {
		cur := heap.Pop(&pq).(*Rec)
		if cur.x == tx && cur.y == ty {
			return int(cur.loss)
		}
		k := cur.K()
		if seen[k] {
			continue
		}
		seen[k] = true
		add(cur.x, cur.y, CW(cur.d), cur.loss)
		add(cur.x, cur.y, CCW(cur.d), cur.loss)
	}
	return 1
}

func Parts(in []byte, args ...int) (int, int) {
	m := NewByteMap(in)
	return Solve(m, 1, 3), Solve(m, 4, 10)
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

type Rec struct {
	x, y, loss int16
	d          Dir
}

func (r *Rec) K() uint32 {
	return (uint32(r.x)*141+uint32(r.y))<<2 + uint32(r.d)
}

type PQ []*Rec

func (pq PQ) Len() int { return len(pq) }

func (pq PQ) Less(i, j int) bool {
	return pq[i].loss < pq[j].loss
}

func (pq PQ) Swap(i, j int) {
	pq[i], pq[j] = pq[j], pq[i]
}

func (pq *PQ) Push(x interface{}) {
	item := x.(*Rec)
	*pq = append(*pq, item)
}

func (pq *PQ) Pop() interface{} {
	old := *pq
	n := len(old)
	item := old[n-1]
	*pq = old[0 : n-1]
	return item
}

type Dir byte

const (
	UP    Dir = 0
	RIGHT Dir = 1
	DOWN  Dir = 2
	LEFT  Dir = 3
)

func (d Dir) X() int16 {
	if d == LEFT {
		return -1
	} else if d == RIGHT {
		return 1
	}
	return 0
}

func (d Dir) Y() int16 {
	if d == UP {
		return -1
	} else if d == DOWN {
		return 1
	}
	return 0
}

func (d Dir) String() string {
	switch d {
	case UP:
		return "^"
	case DOWN:
		return "v"
	case LEFT:
		return "<"
	case RIGHT:
		return ">"
	}
	return "?"
}

func CW(d Dir) Dir {
	if d == LEFT {
		return UP
	}
	return d + 1
}

func CCW(d Dir) Dir {
	if d == UP {
		return LEFT
	}
	return d - 1
}

var benchmark = false
