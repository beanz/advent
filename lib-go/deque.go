package aoc

type Deque[T any] struct {
	array []T
	head  int
	tail  int
	len   int
}

func NewDeque[T any](a []T) *Deque[T] {
	return &Deque[T]{a, 0, 0, 0}
}

func (d *Deque[T]) Clear() {
	d.len = 0
	d.head = 0
	d.tail = 0
}

func (d *Deque[T]) Len() int {
	return d.len
}

func (d *Deque[T]) Push(v T) {
	if d.len == len(d.array) {
		panic("deque full")
	}
	d.array[d.tail] = v
	d.tail += 1
	if d.tail == len(d.array) {
		d.tail = 0
	}
	d.len++
}

func (d *Deque[T]) IsEmpty() bool {
	return d.len == 0
}

func (d *Deque[T]) Pop() T {
	if d.len == 0 {
		panic("deque empty")
	}
	r := d.array[d.head]
	d.head += 1
	if d.head == len(d.array) {
		d.head = 0
	}
	d.len--
	return r
}
