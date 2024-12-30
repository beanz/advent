package aoc

type ReuseableSeen[T AoCInt] struct {
	set   []T
	count T
}

func NewReuseableSeen[T AoCInt](set []T) *ReuseableSeen[T] {
	return &ReuseableSeen[T]{set: set, count: 1}
}

func (r *ReuseableSeen[T]) HaveSeen(e int) bool {
	res := r.set[e] == r.count
	r.set[e] = r.count
	return res
}

func (r *ReuseableSeen[T]) Reset() {
	r.count++
}
