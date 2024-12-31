package aoc

import (
	"fmt"
	"iter"
	"os"
)

type ListOfLists[T AoCInt] struct {
	a  []T
	l  int
	sl int
}

func NewListOfLists[T AoCInt](a []T, l int) *ListOfLists[T] {
	return &ListOfLists[T]{a: a, l: l, sl: len(a) / l}
}

func (l *ListOfLists[T]) Len(i int) int {
	return int(l.a[i*l.sl])
}

func (l *ListOfLists[T]) Dump() {
	fmt.Fprintf(os.Stderr, "%v\n", l)
}

func (l *ListOfLists[T]) Get(i, j int) T {
	o := i * l.sl
	ll := l.a[o]
	if T(j) < ll {
		return l.a[o+j+1]
	}
	panic(fmt.Sprintf("list %d index out of range %d (length %d)", i, j, ll))
}

func (l *ListOfLists[T]) Items(i int) iter.Seq[T] {
	return func(yield func(T) bool) {
		o := i * l.sl
		for j := 1; j <= int(l.a[o]); j++ {
			if !yield(l.a[o+j]) {
				return
			}
		}
	}
}

func (l *ListOfLists[T]) Push(i int, e T) {
	j := l.a[i*l.sl] + 1
	if j >= T(l.sl) {
		panic(fmt.Sprintf("overflow at index %d (length %d)", i, j))
	}
	l.a[i*l.sl] = j
	l.a[i*l.sl+int(j)] = e
}
