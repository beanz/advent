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
	todo := []Search{}
	todo2 := []Search{}
	m.Visit(func(i int, v byte) (byte, bool) {
		if v == 'S' {
			v = 'a'
			todo = append(todo, Search{i, 'a', 0})
			todo2 = append(todo2, Search{i, 'a', 0})
		} else if v == 'E' {
			e = i
			v = 'z'
		} else if v == 'a' {
			todo2 = append(todo2, Search{i, 'a', 0})
			return v, false
		}
		return v, true
	})
	v := make([]bool, 10240)
	for len(todo) > 0 {
		cur := todo[0]
		todo = todo[1:]
		if ok := v[cur.pos]; ok {
			continue
		}
		v[cur.pos] = true
		if cur.pos == e {
			p1 = cur.steps
			break
		}
		for _, nb := range m.Neighbours(cur.pos) {
			nch := m.Get(nb)
			if nch > cur.ch+1 {
				continue
			}
			todo = append(todo, Search{nb, nch, cur.steps + 1})
		}
	}
	v2 := make([]bool, 10240)
	for len(todo2) > 0 {
		cur := todo2[0]
		todo2 = todo2[1:]
		if ok := v2[cur.pos]; ok {
			continue
		}
		v2[cur.pos] = true
		if cur.pos == e {
			p2 = cur.steps
			break
		}
		for _, nb := range m.Neighbours(cur.pos) {
			nch := m.Get(nb)
			if !(nch <= cur.ch+1) {
				continue
			}
			todo2 = append(todo2, Search{nb, nch, cur.steps + 1})
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

var benchmark = false
