package main

import (
	"container/heap"
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Game struct {
	depth  int
	target Point
	cache  map[Point]int
	debug  bool
}

func NewGame(lines []string) *Game {
	target := SimpleReadInts(lines[1])
	return &Game{
		SimpleReadInts(lines[0])[0],
		Point{target[0], target[1]},
		make(map[Point]int, target[0]*target[1]),
		false,
	}
}

func (g *Game) cacheGet(p Point) (int, bool) {
	if v, ok := g.cache[p]; ok {
		return v, true
	}
	return 0, false
}

func (g *Game) cacheSet(p Point, el int) {
	g.cache[p] = el
}

func (g *Game) erosionLevel(p Point) int {
	if el, ok := g.cacheGet(p); ok {
		return el
	}
	var gi int
	if p.X == 0 && p.Y == 0 {
		gi = 0
	} else if p.X == g.target.X && p.Y == g.target.Y {
		gi = 0
	} else if p.Y == 0 {
		gi = p.X * 16807
	} else if p.X == 0 {
		gi = p.Y * 48271
	} else {
		el1 := g.erosionLevel(Point{p.X - 1, p.Y})
		el2 := g.erosionLevel(Point{p.X, p.Y - 1})
		gi = el1 * el2
	}
	el := (gi + g.depth) % 20183
	g.cacheSet(p, el)
	return el
}

func (g *Game) String() string {
	s := ""
	for y := 0; y <= g.target.Y; y++ {
		for x := 0; x <= g.target.X; x++ {
			risk := g.risk(Point{x, y})
			var sq string
			switch risk {
			case 0:
				sq = "."
			case 1:
				sq = "="
			case 2:
				sq = "|"
			}
			s += sq
		}
		s += "\n"
	}
	return s
}

func (g *Game) risk(p Point) Risk {
	return Risk(g.erosionLevel(p) % 3)
}

type Tool int

const (
	None = Tool(iota)
	Torch
	Climbing
)

type Risk int

const (
	Rocky = Risk(iota)
	Wet
	Narrow
)

func (r Risk) String() string {
	switch r {
	case Rocky: // rocky
		return "."
	case Wet: // wet
		return "="
	default: // narrow
		return "|"
	}
}

func (t Tool) String() string {
	switch t {
	case None:
		return "n"
	case Torch:
		return "t"
	default:
		return "c"
	}
}

type Search struct {
	pt   PointTool
	time int
}

type PointTool struct {
	p    Point
	tool Tool
}

func (g *Game) allowedTools(p Point) []Tool {
	switch g.risk(p) {
	case Rocky: // rocky
		return []Tool{Torch, Climbing}
	case Wet: // wet
		return []Tool{None, Climbing}
	default: // narrow
		return []Tool{None, Torch}
	}
}

type PQ []*Search

func (pq PQ) Len() int { return len(pq) }

func (pq PQ) Less(i, j int) bool {
	return pq[i].time < pq[j].time
}

func (pq PQ) Swap(i, j int) {
	pq[i], pq[j] = pq[j], pq[i]
}

func (pq *PQ) Push(x interface{}) {
	item := x.(*Search)
	*pq = append(*pq, item)
}

func (pq *PQ) Pop() interface{} {
	old := *pq
	n := len(old)
	item := old[n-1]
	*pq = old[0 : n-1]
	return item
}

func (g *Game) Part1() int {
	sum := 0
	for y := 0; y <= g.target.Y; y++ {
		for x := 0; x <= g.target.X; x++ {
			sum += int(g.risk(Point{x, y}))
		}
	}
	return sum
}

func (g *Game) Part2() int {
	visited := make(map[PointTool]int, g.target.X*g.target.Y)
	start := Point{0, 0}
	pq := make(PQ, 1)
	pq[0] = &Search{
		PointTool{start, Torch},
		0,
	}
	heap.Init(&pq)
	for pq.Len() > 0 {
		cur := heap.Pop(&pq).(*Search)
		//fmt.Printf("%d\r", pq.Len())
		//fmt.Printf("At %s, terrain %s with %s\n", cur.pt.p, input.risk(cur.pt.p), cur.pt.tool)
		//fmt.Printf("  allowed tools %v\n", input.allowedTools(cur.pt.p))
		//fmt.Printf("%v\n", cur)
		if cur.pt.p.X == g.target.X && cur.pt.p.Y == g.target.Y {
			if cur.pt.tool != Torch {
				cur.time += 7
			}
			return cur.time
		}
		vt, ok := visited[cur.pt]
		if ok && vt <= cur.time {
			continue
		}
		visited[cur.pt] = cur.time
		for _, np := range cur.pt.p.Neighbours() {
			if np.X < 0 || np.Y < 0 {
				continue
			}
			if newTools := g.allowedTools(np); newTools[0] != cur.pt.tool && newTools[1] != cur.pt.tool {
				continue
			}
			npt := PointTool{np, cur.pt.tool}
			if vt, ok := visited[npt]; ok && vt < cur.time+1 {
				continue
			}
			//fmt.Printf("Moving from %s to %s\n", cur.pt, npt)
			heap.Push(&pq, &Search{npt, cur.time + 1})
		}
		for _, tool := range g.allowedTools(cur.pt.p) {
			if tool != cur.pt.tool {
				npt := PointTool{cur.pt.p, tool}
				if vt, ok := visited[npt]; ok && vt < cur.time+7 {
					continue
				}
				//fmt.Printf("Moving from %s to %s\n", cur.pt, npt)
				heap.Push(&pq, &Search{npt, cur.time + 7})
			}
		}
	}
	return -1
}

func main() {
	g := NewGame(InputLines(input))
	p1 := g.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := g.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
