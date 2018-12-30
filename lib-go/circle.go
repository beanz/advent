package aoc

type Circle struct {
	Num int
	Cw  *Circle
	Ccw *Circle
}

func NewCircle(i int) *Circle {
	new := &Circle{i, nil, nil}
	new.Cw = new
	new.Ccw = new
	return new
}

func (e *Circle) Remove() {
	e.Cw.Ccw = e.Ccw
	e.Ccw.Cw = e.Cw
}

func (e *Circle) Add(new *Circle) {
	after := e.Cw
	e.Cw = new
	after.Ccw = new
	new.Ccw = e
	new.Cw = after
}

func (e *Circle) AddNew(i int) *Circle {
	new := NewCircle(i)
	e.Add(new)
	return new
}
