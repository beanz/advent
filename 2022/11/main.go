package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed "input.txt"
var input []byte

type Monkey struct {
	num    int
	items  []int
	c      int
	items2 []int
	div    int
	op     func(old int) int
	throw  func(w int) int
}

func NextMonkey(in []byte, i int) (int, Monkey) {
	if in[i] != 'M' {
		panic("monkey missing")
	}
	n := int(in[i+7] - '0')
	j := i + len("Monkey X:\n  Starting Items: ")
	items := []int{}
	items2 := []int{}
	for {
		k, n := NextUInt(in, j)
		j = k
		items = append(items, n)
		items2 = append(items2, n)
		if in[k] == '\n' {
			break
		}
		j += 2
	}
	j += len("\n  Operation: new = old ")
	var op func(old int) int
	switch in[j] {
	case '+':
		k, n := NextUInt(in, j+2)
		j = k + 1
		op = func(old int) int {
			return old + n
		}
	case '*':
		if in[j+2] == 'o' {
			op = func(old int) int {
				return old * old
			}
			j += 6
		} else {
			k, n := NextUInt(in, j+2)
			j = k + 1
			op = func(old int) int {
				return old * n
			}
		}
	}
	j += len("  Test: divisible by ")
	k, div := NextUInt(in, j)
	j = k + 1 + len("    If true: throw to monkey ")
	k, tm := NextUInt(in, j)
	j = k + 1 + len("    If false: throw to monkey ")
	k, fm := NextUInt(in, j)
	j = k + 1
	throw := func(w int) int {
		if w%div == 0 {
			return tm
		} else {
			return fm
		}
	}
	return j, Monkey{n, items, 0, items2, div, op, throw}
}

type Business struct {
	mk     []Monkey
	reduce func(w int) int
	lcm    int
}

func (mb *Business) MonkeyDo(i int) {
	for len(mb.mk[i].items) != 0 {
		mb.mk[i].c++
		w := mb.mk[i].items[0]
		mb.mk[i].items = mb.mk[i].items[1:]
		w = mb.mk[i].op(w)
		w = mb.reduce(w)
		to := mb.mk[i].throw(w)
		mb.mk[to].items = append(mb.mk[to].items, w)
	}
}

func (mb *Business) Solve(rounds int) int {
	for r := 1; r <= rounds; r++ {
		for i := 0; i < len(mb.mk); i++ {
			mb.MonkeyDo(i)
		}
	}
	m1, m2 := 0, 0
	for _, m := range mb.mk {
		c := m.c
		if c > m1 {
			c, m1 = m1, c
		}
		if c > m2 {
			m2 = c
		}
	}
	return m1 * m2
}

func Parts(in []byte) (int, int) {
	reduce := func(x int) int { return x / 3 }
	mb := Business{[]Monkey{}, reduce, 1}
	for i := 0; i < len(in); i++ {
		j, m := NextMonkey(in, i)
		mb.mk = append(mb.mk, m)
		mb.lcm *= m.div
		i = j
	}
	p1 := mb.Solve(20)
	for i := range mb.mk {
		mb.mk[i].items = mb.mk[i].items2
		mb.mk[i].c = 0
	}
	mb.reduce = func(w int) int {
		return w % mb.lcm
	}
	p2 := mb.Solve(10000)
	return p1, p2
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

func NextUInt(in []byte, i int) (j int, n int) {
	j = i
	for ; '0' <= in[j] && in[j] <= '9'; j++ {
		n = 10*n + int(in[j]-'0')
	}
	return
}

var benchmark = false
