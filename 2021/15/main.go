package main

import (
	"container/heap"
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Cave struct {
	m      *ByteMap
	dim    uint16
	mw, mh uint16
	w, h   uint16
}

func NewCave(in []byte) *Cave {
	m := NewByteMap(in)
	c := &Cave{m, 1, uint16(m.Width()), uint16(m.Height()),
		uint16(m.Width()), uint16(m.Height())}
	return c
}

func (c *Cave) SetDim(n uint16) {
	c.dim = n
	c.w = c.mw * n
	c.h = c.mh * n
}

func (c *Cave) Risk(x, y uint16) uint16 {
	v := c.m.GetXY(int(x%c.mw), int(y%c.mh)) - '0'
	v += byte(x / c.mw)
	v += byte(y / c.mh)
	for v > 9 {
		v -= 9
	}
	return uint16(v)
}

type Rec struct {
	x, y uint16
	risk uint16
}

//type Search []Rec

type PQ []*Rec

func (pq PQ) Len() int { return len(pq) }

func (pq PQ) Less(i, j int) bool {
	return pq[i].risk < pq[j].risk
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

func (c *Cave) Solve() uint16 {
	visited := make([]bool, uint32(c.w)*uint32(c.h))
	pq := make(PQ, 1, 10240)
	pq[0] = &Rec{0, 0, 0}
	heap.Init(&pq)
	for pq.Len() > 0 {
		cur := heap.Pop(&pq).(*Rec)
		if cur.x == c.w-1 && cur.y == c.h-1 {
			return cur.risk
		}
		vk := uint32(cur.x) + uint32(cur.y)*uint32(c.w)
		if visited[vk] {
			continue
		}
		visited[vk] = true
		if cur.x > 0 {
			risk := cur.risk + c.Risk(cur.x-1, cur.y)
			heap.Push(&pq, &Rec{cur.x - 1, cur.y, risk})
		}
		if cur.x < c.w-1 {
			risk := cur.risk + c.Risk(cur.x+1, cur.y)
			heap.Push(&pq, &Rec{cur.x + 1, cur.y, risk})
		}
		if cur.y > 0 {
			risk := cur.risk + c.Risk(cur.x, cur.y-1)
			heap.Push(&pq, &Rec{cur.x, cur.y - 1, risk})
		}
		if cur.y < c.h-1 {
			risk := cur.risk + c.Risk(cur.x, cur.y+1)
			heap.Push(&pq, &Rec{cur.x, cur.y + 1, risk})
		}
	}
	return 0
}

func (c *Cave) Part1() uint16 {
	c.SetDim(1)
	return c.Solve()
}

func (c *Cave) Part2() uint16 {
	c.SetDim(5)
	return c.Solve()
}

func main() {
	c := NewCave(InputBytes(input))
	p1 := c.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := c.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
