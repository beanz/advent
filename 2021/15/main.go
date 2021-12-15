package main

import (
	_ "embed"
	"container/heap"
	"fmt"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Cave struct {
	m *ByteMap
	dim int
	mw, mh int
	w, h int
}

func NewCave(in []byte) *Cave {
	m := NewByteMap(in)
	c := &Cave{m, 1, m.Width(), m.Height(), m.Width(), m.Height()}
	return c
}

func (c *Cave) SetDim(n int) {
	c.dim = n
	c.w = c.mw*n
	c.h = c.mh*n
}

func (c *Cave) Risk(x, y int) byte {
	v := c.m.GetXY(x %c.mw, y % c.mh)-'0'
	v += byte(x/c.mw)
	v += byte(y/c.mh)
	for ;v>9; {
		v-=9
	}
	return v
}

type Rec struct {
	x, y int
	risk int
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

func (c *Cave) Solve() int {
	visited := make(map[int]int, c.mw*c.mh)
	pq := make(PQ, 1)
	pq[0] = &Rec{0, 0, 0}
	heap.Init(&pq)
	for pq.Len() > 0 {
		cur := heap.Pop(&pq).(*Rec)
		if cur.x == c.w-1 && cur.y == c.h-1 {
			return cur.risk
		}
		vk := cur.x + (cur.y<<10)
		if v, ok := visited[vk]; ok && v <= cur.risk {
			continue
		}
		visited[vk] = cur.risk
		for _, o := range [][]int{{0,-1}, {1,0}, {0,1}, {-1,0}} {
			x := cur.x + o[0]
			y := cur.y + o[1]
			if x <0 || y <0 || x >= c.w || y >= c.h {
				continue
			}
			nr := c.Risk(x, y)
			risk := cur.risk + int(nr)
			heap.Push(&pq, &Rec{x, y, risk})
		}
	}
	return -1
}

func (c *Cave) Part1() int {
	c.SetDim(1)
	return c.Solve()
}

func (c *Cave) Part2() int {
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
