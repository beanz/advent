package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Search struct {
	x, y  int
	ch    byte
	steps int
}

func Parts(in []byte) (int, int) {
	m := NewByteMap(in)
	var ex, ey int
	todoArray := [100]Search{}
	todo := NewDeque(todoArray[0:])
	todo2Array := [3000]Search{}
	todo2 := NewDeque(todo2Array[0:])
	m.VisitXY(func(x, y int, v byte) (byte, bool) {
		if v == 'S' {
			v = 'a'
			todo.Push(Search{x, y, 'a', 0})
			todo2.Push(Search{x, y, 'a', 0})
		} else if v == 'E' {
			ex, ey = x, y
			v = 'z'
		} else if v == 'a' {
			todo2.Push(Search{x, y, 'a', 0})
			return v, false
		}
		return v, true
	})
	return Solve(m, todo, ex, ey), Solve(m, todo2, ex, ey)
}

func Solve(m *ByteMap, todo *Deque[Search], ex, ey int) int {
	w := m.Width()
	v := [10240]bool{}
	for todo.Len() > 0 {
		cur := todo.Pop()
		if ok := v[cur.x+cur.y*w]; ok {
			continue
		}
		v[cur.x+cur.y*w] = true
		if cur.x == ex && cur.y == ey {
			return cur.steps
		}
		m.VisitNeighboursXY(cur.x, cur.y, func(nx, ny int, nch byte) {
			if nch > cur.ch+1 || v[nx+ny*w] {
				return
			}
			todo.Push(Search{nx, ny, nch, cur.steps + 1})
		})
	}
	return -1
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false