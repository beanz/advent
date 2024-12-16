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

const QUEUE = 262144

func Parts(in []byte, args ...int) (int, int) {
	w := bytes.IndexByte(in, '\n')
	h := len(in) / (w + 1)
	w1 := w + 1
	sx, sy := 1, h-2
	tx, ty := w-2, 1
	pq := make(PQ, 0, 2000)
	pq = append(pq, &Rec{x: sx, y: sy, dir: 1, cost: 0})
	push := func(x, y, cost int, dir byte) {
		heap.Push(&pq, &Rec{x, y, cost, dir})
	}
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
			push(nx, ny, cur.cost+1, cur.dir)
		}
		push(cur.x, cur.y, cur.cost+1000, (cur.dir+1)&3)
		push(cur.x, cur.y, cur.cost+1000, (cur.dir+3)&3)
	}
	pq = pq[:0]
	for d := byte(0); d < 4; d++ {
		push(tx, ty, 0, d)
	}
	seen = [80000]bool{}
	p2set := [80000]bool{}
	p2 := 0
	for pq.Len() > 0 {
		cur := heap.Pop(&pq).(*Rec)
		k := cur.K()
		cost := cur.cost + sd[k] - 1
		if cost > p1 {
			continue
		}
		if cost == p1 {
			if !p2set[k&^3] {
				p2++
				p2set[k&^3] = true
			}
		}
		if seen[k] {
			continue
		}
		seen[k] = true
		nx, ny := cur.x-DX[cur.dir], cur.y-DY[cur.dir]
		if in[nx+ny*w1] != '#' {
			push(nx, ny, cur.cost+1, cur.dir)
		}
		push(cur.x, cur.y, cur.cost+1000, (cur.dir+1)&3)
		push(cur.x, cur.y, cur.cost+1000, (cur.dir+3)&3)
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

func (pq PQ) Less(i, j int) bool { return pq[i].cost < pq[j].cost }

func (pq PQ) Swap(i, j int) { pq[i], pq[j] = pq[j], pq[i] }

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
