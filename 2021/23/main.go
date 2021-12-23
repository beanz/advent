package main

import (
	"container/heap"
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
	"sort"
	"strings"
)

//go:embed input.txt
var input []byte

type Position byte

const NoPosition = Position(99)

func NewPosition(x, y int) Position {
	if y == 1 {
		return Position(x - 1)
	}
	return Position(11 + (x-1)/2 - 1 + 4*(y-2))
}

func (p Position) XY() (int, int) {
	if p < 11 {
		return int(p) + 1, 1
	}
	n := int(p) - 11
	x := (n%4)*2 + 3
	y := 2 + n/4
	return x, y
}

func (p Position) String() string {
	x, y := p.XY()
	return fmt.Sprintf("%d,%d", x, y)
}

type Amphipod struct {
	ch byte
	me int
	hx int
}

func NewAmphipod(ch byte) Amphipod {
	me := 1
	for j := 0; j < int(ch-'A'); j++ {
		me *= 10
	}
	return Amphipod{ch, me, 3 + 2*int(ch-'A')}
}

type State struct {
	energy   int
	m        map[Position]Amphipod
	homeSize int
}

func (s *State) String() string {
	var sb strings.Builder
	sb.WriteString("#############\n#")
	for i := 0; i < 11; i++ {
		if amp, ok := s.m[Position(i)]; ok {
			sb.WriteByte(amp.ch)
		} else {
			sb.WriteByte('.')
		}
	}
	sb.WriteString("#\n###")
	for i := 11; i < 15; i++ {
		if amp, ok := s.m[Position(i)]; ok {
			sb.WriteByte(amp.ch)
		} else {
			sb.WriteByte('.')
		}
		sb.WriteByte('#')
	}
	sb.WriteString("##\n")
	for h := 2; h <= s.homeSize; h++ {
		sb.WriteString("  #")
		for i := 11 + 4*(h-1); i < 15+4*(h-1); i++ {
			if amp, ok := s.m[Position(i)]; ok {
				sb.WriteByte(amp.ch)
			} else {
				sb.WriteByte('.')
			}
			sb.WriteByte('#')
		}
		sb.WriteString("\n")
	}
	sb.WriteString("  #########\n")
	return sb.String()
}

func (s *State) Key() string {
	ki := make([]int, 0, 16)
	for pos, amp := range s.m {
		ki = append(ki, int(pos)<<8+int(amp.ch))
	}
	sort.Ints(ki)
	var sb strings.Builder
	for _, v := range ki {
		sb.WriteByte(byte(v % 256))
		sb.WriteByte(byte(v >> 8))
	}
	return sb.String()
}

func (s *State) IsHome(pos Position) bool {
	x, y := pos.XY()
	amp := s.m[pos]
	if x != amp.hx {
		return false
	}
	for hy := s.homeSize + 1; hy > y; hy-- {
		if ta, ok := s.m[NewPosition(amp.hx, hy)]; ok && amp.ch != ta.ch {
			return false
		}
	}
	return true
}

func (s *State) Done() bool {
	for pos := range s.m {
		if !s.IsHome(pos) {
			return false
		}
	}
	return true
}

func (s *State) Home(pos Position) Position {
	amp := s.m[pos]
	hx := amp.hx
	for hy := s.homeSize + 1; hy >= 2; hy-- {
		ta, ok := s.m[NewPosition(amp.hx, hy)]
		if !ok {
			return NewPosition(hx, hy)
		}
		if ta.ch != amp.ch {
			return NoPosition
		}
	}
	return NoPosition
}

func (s *State) PathClear(pos Position, new Position) (int, bool) {
	x, y := pos.XY()
	nx, ny := new.XY()
	cost := 0
	for x != nx || y != ny {
		switch {
		case nx == x:
			y++
		case y != 1:
			y--
		case x > nx:
			x--
		case x < nx:
			x++
		}
		npos := NewPosition(x, y)
		if _, ok := s.m[npos]; ok {
			return 0, false
		}
		cost++
	}
	return cost, true
}

type MoveCost struct {
	pos  Position
	cost int
}

func (mc MoveCost) String() string {
	return fmt.Sprintf("%s/%d", mc.pos.String(), mc.cost)
}

func (s *State) Moves(pos Position) []MoveCost {
	// no moves if we are home already
	if s.IsHome(pos) {
		return []MoveCost{}
	}
	x, y := pos.XY()
	home := s.Home(pos)
	if home != NoPosition {
		if cost, clear := s.PathClear(pos, home); clear {
			return []MoveCost{{home, cost}}
		}
	}
	if y == 1 {
		// can only move home from row 1
		return []MoveCost{}
	}
	res := make([]MoveCost, 0, 7)
	if 1 < x {
		npos := NewPosition(1, 1)
		if cost, clear := s.PathClear(pos, npos); clear {
			res = append(res, MoveCost{npos, cost})
		}
	}
	for mx := 2; mx < 12; mx += 2 {
		npos := NewPosition(mx, 1)
		if cost, clear := s.PathClear(pos, npos); clear {
			res = append(res, MoveCost{npos, cost})
		}
	}

	npos := NewPosition(11, 1)
	if cost, clear := s.PathClear(pos, npos); clear {
		res = append(res, MoveCost{npos, cost})
	}
	return res
}

type Game struct {
	init State
}

func NewGame(in []byte) *Game {
	x, y := 0, 0
	init := make(map[Position]Amphipod, 8)
	for i := range in {
		if in[i] == '\n' {
			x = 0
			y++
		} else if 'A' <= in[i] && in[i] <= 'D' {
			//fmt.Printf("%d,%d: %s %d %d\n",
			//	x, y, string(in[i]), me, 3+2*int(in[i]-'A'))
			pos := NewPosition(x, y)
			init[pos] = NewAmphipod(in[i])
		}
		x++
	}
	//fmt.Printf("%d\n", y-3)
	return &Game{State{0, init, y - 3}}
}

type PQ []*State

func (pq PQ) Len() int { return len(pq) }

func (pq PQ) Less(i, j int) bool {
	return pq[i].energy < pq[j].energy
}

func (pq PQ) Swap(i, j int) {
	pq[i], pq[j] = pq[j], pq[i]
}

func (pq *PQ) Push(x interface{}) {
	item := x.(*State)
	*pq = append(*pq, item)
}

func (pq *PQ) Pop() interface{} {
	old := *pq
	n := len(old)
	item := old[n-1]
	*pq = old[0 : n-1]
	return item
}

func (g *Game) Solve(state *State) int {
	visited := make(map[string]bool, 100000)
	pq := make(PQ, 1)
	pq[0] = state
	heap.Init(&pq)
	for pq.Len() > 0 {
		cur := heap.Pop(&pq).(*State)
		if cur.Done() {
			return cur.energy
		}
		vk := cur.Key()
		if _, ok := visited[vk]; ok {
			continue
		}
		visited[vk] = true
		for pos, amp := range cur.m {
			for _, moveCost := range cur.Moves(pos) {
				n := &State{cur.energy + moveCost.cost*amp.me,
					make(map[Position]Amphipod, len(cur.m)),
					cur.homeSize}
				for k, v := range cur.m {
					if k != pos {
						n.m[k] = v
					} else {
						n.m[moveCost.pos] = v
					}
				}
				heap.Push(&pq, n)
			}
		}
	}
	return 1
}

func (g *Game) Part1() int {
	return g.Solve(&g.init)
}

func (g *Game) Part2() int {
	n := &State{0,
		make(map[Position]Amphipod, len(g.init.m)+8),
		g.init.homeSize + 2}
	for k, v := range g.init.m {
		x, y := k.XY()
		if y == 3 {
			n.m[NewPosition(x, y+2)] = v
		} else {
			n.m[k] = v
		}
	}
	// #D#C#B#A#
	// #D#B#A#C#
	n.m[NewPosition(3, 3)] = NewAmphipod('D')
	n.m[NewPosition(3, 4)] = NewAmphipod('D')
	n.m[NewPosition(5, 3)] = NewAmphipod('C')
	n.m[NewPosition(5, 4)] = NewAmphipod('B')
	n.m[NewPosition(7, 3)] = NewAmphipod('B')
	n.m[NewPosition(7, 4)] = NewAmphipod('A')
	n.m[NewPosition(9, 3)] = NewAmphipod('A')
	n.m[NewPosition(9, 4)] = NewAmphipod('C')
	return g.Solve(n)
}

func main() {
	g := NewGame(InputBytes(input))
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
