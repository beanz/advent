package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Search struct {
	pos   int
	ch    byte
	steps int
}

func Parts(in []byte) (int, int) {
	m := NewByteMap(in)
	p1, p2 := -1, -1
	var e int
	todoArray := [100]Search{}
	todo := NewDeque(todoArray[0:])
	todo2Array := [3000]Search{}
	todo2 := NewDeque(todo2Array[0:])
	m.Visit(func(i int, v byte) (byte, bool) {
		if v == 'S' {
			v = 'a'
			todo.Push(Search{i, 'a', 0})
			todo2.Push(Search{i, 'a', 0})
		} else if v == 'E' {
			e = i
			v = 'z'
		} else if v == 'a' {
			todo2.Push(Search{i, 'a', 0})
			return v, false
		}
		return v, true
	})
	v := [10240]bool{}
	for todo.Len() > 0 {
		cur := todo.Pop()
		if ok := v[cur.pos]; ok {
			continue
		}
		v[cur.pos] = true
		if cur.pos == e {
			p1 = cur.steps
			break
		}
		m.VisitNeighbours(cur.pos, func(nb int, nch byte) {
			if nch > cur.ch+1 || v[nb] {
				return
			}
			todo.Push(Search{nb, nch, cur.steps + 1})
		})
	}
	v2 := [10240]bool{}
	for todo2.Len() > 0 {
		cur := todo2.Pop()
		if ok := v2[cur.pos]; ok {
			continue
		}
		v2[cur.pos] = true
		if cur.pos == e {
			p2 = cur.steps
			break
		}
		m.VisitNeighbours(cur.pos, func(nb int, nch byte) {
			if nch > cur.ch+1 || v2[nb] {
				return
			}
			todo2.Push(Search{nb, nch, cur.steps + 1})
		})
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

var benchmark = false
