package aoc

import (
	"bytes"
)

type IDType interface {
	Add(p int, ch byte) int
	Char(c int) byte
	Size() int
}

type LowerAZID struct{}

func (l LowerAZID) Add(p int, ch byte) int {
	return p*27 + int(ch-'a'+1)
}

func (l LowerAZID) Size() int {
	return 27
}

func (l LowerAZID) Char(c int) byte {
	return byte(c-1) + 'a'
}

type UpperAZID struct{}

func (l UpperAZID) Add(p int, ch byte) int {
	return p*27 + int(ch-'A'+1)
}

func (l UpperAZID) Size() int {
	return 27
}

func (l UpperAZID) Char(c int) byte {
	return byte(c-1) + 'A'
}

type IDBuilder struct {
	t IDType
	n int
	l int
}

func NewIDBuilder(t IDType, l int) *IDBuilder {
	return &IDBuilder{t: t, l: l, n: 0}
}

func (i *IDBuilder) Reset() {
	i.n = 0
}

func (i *IDBuilder) Add(ch byte) int {
	i.n = i.t.Add(i.n, ch)
	return i.n
}

func (i *IDBuilder) Size() int {
	s := 1
	for j := 0; j < i.l; j++ {
		s *= i.t.Size()
	}
	return 1 + s
}

func (i *IDBuilder) Pretty(n int) string {
	size := i.t.Size()
	m := size
	for ; m < n; m *= size {
	}
	m /= size
	var b bytes.Buffer
	for ; m > 0; m /= size {
		c := n / m
		c %= size
		b.WriteByte(i.t.Char(c))
	}
	return b.String()
}

type IDTracker interface {
	Add(w []byte) int
	Len() int
	Pretty(n int) string
}

type ListIDTracker []int

func NewListIDTracker(l int) ListIDTracker {
	return make(ListIDTracker, 0, l)
}

func (t *ListIDTracker) Len() int {
	return len(*t)
}

func (t *ListIDTracker) Add(w []byte) int {
	n := 0
	for _, ch := range w {
		n = 63*n + AlphaNum(ch)
	}
	for i, v := range *t {
		if v == n {
			return i
		}
	}
	*t = append(*t, n)
	return len(*t) - 1
}

func (t *ListIDTracker) Pretty(i int) string {
	return NumString((*t)[i])
}

type List2IDTracker struct {
	c int
	l []*int
}

func NewList2IDTracker(l int) *List2IDTracker {
	return &List2IDTracker{c: 0, l: make([]*int, l)}
}

func (t *List2IDTracker) Len() int {
	return t.c
}

func (t *List2IDTracker) Add(w []byte) int {
	n := 0
	for _, ch := range w {
		n = 63*n + AlphaNum(ch)
	}
	p := t.l[n]
	if p != nil {
		return *p
	}
	id := t.c
	t.l[n] = &id
	t.c++
	return id
}

func (t *List2IDTracker) Pretty(i int) string {
	for n, id := range t.l {
		if id != nil && *id == i {
			return NumString(n)
		}
	}
	return "404-not-found"
}

func NumString(n int) string {
	m := 63
	for ; m < n; m *= 63 {
	}
	m /= 63
	var b bytes.Buffer
	for ; m > 0; m /= 63 {
		c := n / m
		c %= 63
		b.WriteByte(NumAlpha(c))
	}
	return b.String()
}

func NumAlpha(c int) byte {
	switch {
	case c < 11:
		return byte(c-1) + '0'
	case c < 37:
		return byte(c-11) + 'A'
	default:
		return byte(c-37) + 'a'
	}
}

func AlphaNum(ch byte) int {
	switch {
	case ch >= 97:
		ch -= (6 + 7 + 48)
	case ch >= 65:
		ch -= (7 + 48)
	case ch >= 48:
		ch -= 48
	}
	return int(1 + ch)
}
