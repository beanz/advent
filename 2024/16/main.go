package main

import (
	"bytes"
	"container/heap"
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

var DX = [4]int{0, 1, 0, -1}
var DY = [4]int{-1, 0, 1, 0}

func Parts(in []byte, args ...int) (int, int) {
	w := bytes.IndexByte(in, '\n')
	h := len(in) / (w + 1)
	w1 := w + 1
	sx, sy := 1, h-2
	tx, ty := w-2, 1
	pq := make(PQ, 0, 2048)
	pq = append(pq, &Rec{x: sx, y: sy, dir: 1, cost: 0})
	heap.Init(&pq)
	seen := [80000]bool{}
	sd := [80000]int{}
	p1 := 0
	for pq.Len() > 0 {
		cur := heap.Pop(&pq).(*Rec)
		k := cur.K()
		if sd[k] == 0 {
			sd[k] = 1 + cur.cost
		}
		if p1 != 0 {
			if cur.cost > p1 {
				continue
			}
		} else {
			if cur.x == tx && cur.y == ty {
				p1 = cur.cost
			}
		}
		if seen[k] {
			continue
		}
		seen[k] = true
		nx, ny := cur.x+DX[cur.dir], cur.y+DY[cur.dir]
		if in[nx+ny*w1] != '#' {
			heap.Push(&pq, &Rec{nx, ny, cur.cost + 1, cur.dir})
		}
		heap.Push(&pq, &Rec{cur.x, cur.y, cur.cost + 1000, (cur.dir + 1) & 3})
		heap.Push(&pq, &Rec{cur.x, cur.y, cur.cost + 1000, (cur.dir + 3) & 3})
	}
	pq = make(PQ, 0, 2048)
	for d := byte(0); d < 4; d++ {
		pq = append(pq, &Rec{x: tx, y: ty, dir: d, cost: 0})
	}
	heap.Init(&pq)
	seen = [80000]bool{}
	td := [80000]int{}
	for pq.Len() > 0 {
		cur := heap.Pop(&pq).(*Rec)
		k := cur.K()
		if cur.cost > p1 {
			continue
		}
		if td[k] == 0 {
			td[k] = 1 + cur.cost
		}
		if seen[k] {
			continue
		}
		seen[k] = true
		nx, ny := cur.x-DX[cur.dir], cur.y-DY[cur.dir]
		if in[nx+ny*w1] != '#' {
			heap.Push(&pq, &Rec{nx, ny, cur.cost + 1, cur.dir})
		}
		heap.Push(&pq, &Rec{cur.x, cur.y, cur.cost + 1000, (cur.dir + 1) & 3})
		heap.Push(&pq, &Rec{cur.x, cur.y, cur.cost + 1000, (cur.dir + 3) & 3})
	}
	seats := [80000]bool{}
	p2 := 0
	for y := 0; y < h; y++ {
		for x := 0; x < w; x++ {
			for d := byte(0); d < 4; d++ {
				k := (uint32(x)*141+uint32(y))<<2 + uint32(d)
				sd := sd[k] - 1
				td := td[k] - 1
				if sd == -1 || td == -1 {
					continue
				}
				if sd+td == p1 {
					k = (uint32(x)*141 + uint32(y)) << 2
					if !seats[k] {
						p2++
					}
					seats[k] = true
				}
			}
		}
	}
	return p1, p2
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

type Rec struct {
	x, y, cost int
	dir        byte
}

func (r *Rec) K() uint32 {
	return (uint32(r.x)*141+uint32(r.y))<<2 + uint32(r.dir)
}

type PQ []*Rec

func (pq PQ) Len() int { return len(pq) }

func (pq PQ) Less(i, j int) bool {
	return pq[i].cost < pq[j].cost
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

var benchmark = false
