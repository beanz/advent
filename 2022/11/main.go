package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed "input.txt"
var input []byte

type Op int

const (
	ADD Op = iota
	MUL
	SQ
)

type Monkey struct {
	c       int
	l       int
	items   [32]int
	l2      int
	items2  [32]int
	div     int
	op      Op
	operand int
	toT     int
	toF     int
}

func NextMonkey(in []byte, i int) (int, Monkey) {
	if in[i] != 'M' {
		panic("monkey missing")
	}
	j := i + 28
	items := [32]int{}
	items2 := [32]int{}
	l := 0
	for {
		k, n := NextUInt(in, j)
		j = k
		items[l] = n
		items2[l] = n
		l++
		if in[k] == '\n' {
			break
		}
		j += 2
	}
	j += 24
	var op Op
	var operand int
	switch in[j] {
	case '+':
		k, n := NextUInt(in, j+2)
		j = k + 1
		op = ADD
		operand = n
	case '*':
		if in[j+2] == 'o' {
			op = SQ
			j += 6
		} else {
			k, n := NextUInt(in, j+2)
			j = k + 1
			op = MUL
			operand = n
		}
	}
	j += 21
	k, div := NextUInt(in, j)
	j = k + 30
	k, tm := NextUInt(in, j)
	j = k + 31
	k, fm := NextUInt(in, j)
	j = k + 1
	return j, Monkey{0, l, items, l, items2, div, op, operand, tm, fm}
}

type Business struct {
	mk  [8]Monkey
	l   int
	lcm int
}

func (mb *Business) MonkeyDo(i int, reduce int) {
	for j := 0; j < mb.mk[i].l; j++ {
		mb.mk[i].c++
		w := mb.mk[i].items[j]
		switch mb.mk[i].op {
		case ADD:
			w = w + mb.mk[i].operand
		case MUL:
			w = w * mb.mk[i].operand
		case SQ:
			w = w * w
		}
		if reduce == 0 {
			w /= 3
		} else if w >= reduce {
			w %= reduce
		}
		var to int
		if w%mb.mk[i].div == 0 {
			to = mb.mk[i].toT
		} else {
			to = mb.mk[i].toF
		}
		mb.mk[to].items[mb.mk[to].l] = w
		mb.mk[to].l++
	}
	mb.mk[i].l = 0
}

func (mb *Business) Solve(rounds, reduce int) int {
	for r := 1; r <= rounds; r++ {
		for i := 0; i < mb.l; i++ {
			mb.MonkeyDo(i, reduce)
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
	mb := Business{[8]Monkey{}, 0, 1}
	for i := 0; i < len(in); i++ {
		j, m := NextMonkey(in, i)
		mb.mk[mb.l] = m
		mb.l++
		mb.lcm *= m.div
		i = j
	}
	p1 := mb.Solve(20, 0)
	for i := range mb.mk {
		mb.mk[i].items = mb.mk[i].items2
		mb.mk[i].l = mb.mk[i].l2
		mb.mk[i].c = 0
	}
	p2 := mb.Solve(10000, mb.lcm)
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
