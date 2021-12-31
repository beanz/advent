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
	m        []*Amphipod
	homeSize int
}

func (s *State) String() string {
	var sb strings.Builder
	sb.WriteString("#############\n#")
	for i := 0; i < 11; i++ {
		if amp := s.m[Position(i)]; amp != nil {
			sb.WriteByte(amp.ch)
		} else {
			sb.WriteByte('.')
		}
	}
	sb.WriteString("#\n###")
	for i := 11; i < 15; i++ {
		if amp := s.m[Position(i)]; amp != nil {
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
			if amp := s.m[Position(i)]; amp != nil {
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
		if amp == nil {
			continue
		}
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
		if ta := s.m[NewPosition(amp.hx, hy)]; ta != nil && amp.ch != ta.ch {
			return false
		}
	}
	return true
}

func (s *State) Done() bool {
	for pos, amp := range s.m {
		if amp == nil {
			continue
		}
		if !s.IsHome(Position(pos)) {
			return false
		}
	}
	return true
}

func (s *State) Home(pos Position) Position {
	amp := s.m[pos]
	hx := amp.hx
	for hy := s.homeSize + 1; hy >= 2; hy-- {
		ta := s.m[NewPosition(amp.hx, hy)]
		if ta == nil {
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
			if y < ny {
				y++
			} else {
				y--
			}
		case y != 1:
			y--
		case x > nx:
			x--
		case x < nx:
			x++
		}
		npos := NewPosition(x, y)
		if s.m[npos] != nil {
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
		return nil
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
		return nil
	}
	rowOnePos := NewPosition(x, 1)
	costToRowOne, clear := s.PathClear(pos, rowOnePos)
	if !clear {
		return nil
	}
	res := make([]MoveCost, 0, 7)
	for nx, cost := x-1, costToRowOne; nx >= 1; nx, cost = nx-1, cost+1 {
		npos := NewPosition(nx, 1)
		if s.m[npos] != nil {
			break
		}
		if nx == 3 || nx == 5 || nx == 7 || nx == 9 {
			continue
		}
		res = append(res, MoveCost{npos, cost + 1})
	}
	for nx, cost := x+1, costToRowOne; nx <= 11; nx, cost = nx+1, cost+1 {
		npos := NewPosition(nx, 1)
		if s.m[npos] != nil {
			break
		}
		if nx == 3 || nx == 5 || nx == 7 || nx == 9 {
			continue
		}
		res = append(res, MoveCost{npos, cost + 1})
	}
	return res
}

type Game struct {
	init State
}

func NewGame(in []byte) *Game {
	x, y := 0, 0
	init := make([]*Amphipod, 27)
	for i := range in {
		if in[i] == '\n' {
			x = 0
			y++
		} else if 'A' <= in[i] && in[i] <= 'D' {
			//fmt.Printf("%d,%d: %s %d %d\n",
			//	x, y, string(in[i]), me, 3+2*int(in[i]-'A'))
			pos := NewPosition(x, y)
			amp := NewAmphipod(in[i])
			init[pos] = &amp
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
			if amp == nil {
				continue
			}
			moves := cur.Moves(Position(pos))
			if moves == nil {
				continue
			}
			for _, moveCost := range moves {
				n := &State{cur.energy + moveCost.cost*amp.me,
					make([]*Amphipod, len(cur.m)),
					cur.homeSize}
				copy(n.m, cur.m)
				n.m[moveCost.pos], n.m[pos] = n.m[pos], nil
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
		make([]*Amphipod, len(g.init.m)+8),
		g.init.homeSize + 2}
	for i, amp := range g.init.m {
		if amp == nil {
			continue
		}
		x, y := Position(i).XY()
		if y == 3 {
			n.m[NewPosition(x, y+2)] = amp
		} else {
			n.m[i] = amp
		}
	}
	// #D#C#B#A#
	// #D#B#A#C#
	nd := NewAmphipod('D')
	nc := NewAmphipod('C')
	nb := NewAmphipod('B')
	na := NewAmphipod('A')
	n.m[NewPosition(3, 3)] = &nd
	n.m[NewPosition(3, 4)] = &nd
	n.m[NewPosition(5, 3)] = &nc
	n.m[NewPosition(5, 4)] = &nb
	n.m[NewPosition(7, 3)] = &nb
	n.m[NewPosition(7, 4)] = &na
	n.m[NewPosition(9, 3)] = &na
	n.m[NewPosition(9, 4)] = &nc
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
