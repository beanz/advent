package aoc

import "iter"

func IterInts[T AoCSigned](in []byte) iter.Seq[T] {
	return func(yield func(T) bool) {
		for i := 0; i < len(in); {
			j, n := ChompInt[T](in, i)
			i = j + 1
			if !yield(n) {
				return
			}
		}
	}
}

func IterUInts[T AoCInt](in []byte) iter.Seq[T] {
	return func(yield func(T) bool) {
		for i := 0; i < len(in); {
			j, n := ChompUInt[T](in, i)
			i = j + 1
			if !yield(n) {
				return
			}
		}
	}
}
