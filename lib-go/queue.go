package aoc

type Queue[T any] struct {
	buf []T
	head int
	tail int
	len int
	max int
}

func NewQueue[T any](buf []T) *Queue[T] {
	return &Queue[T] { buf, 0, 0, 0, len(buf) }
}

func (q *Queue[T]) Len() int {
	return q.len
}

func (q *Queue[T]) Empty() bool {
	return q.len == 0
}

func (q *Queue[T]) Push(i T) {
  if q.len == q.max {
		panic("queue full")
	}
	q.buf[q.tail] = i
	q.tail++
	if q.tail == q.max {
		q.tail = 0
	}
	q.len++
}

func (q *Queue[T]) Pop() T {
  if q.len == 0 {
		panic("pop on empty")
	}
	i := q.buf[q.head]
	q.head++
	if q.head == q.max {
		q.head = 0
	}
	q.len--
	return i
}
