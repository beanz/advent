package main

import (
	"fmt"
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestPrependInt(t *testing.T) {
	assert.EqualValues(t, Cube{0}, PrependInt(0, Cube{}))
	assert.EqualValues(t, Cube{1, 0}, PrependInt(1, Cube{0}))
}

func TestNeighbours(t *testing.T) {
	assert.EqualValues(t, []Cube{Cube{-1}, Cube{1}}, Cube{0}.Neighbours())
	assert.EqualValues(t, []Cube{
		Cube{-1, -1}, Cube{0, -1}, Cube{1, -1},
		Cube{-1, 0}, Cube{1, 0},
		Cube{-1, 1}, Cube{0, 1}, Cube{1, 1},
	}, Cube{0, 0}.Neighbours())
	assert.EqualValues(t, []Cube{
		Cube{-1, -1, -1}, Cube{0, -1, -1}, Cube{1, -1, -1},
		Cube{-1, 0, -1}, Cube{0, 0, -1}, Cube{1, 0, -1},
		Cube{-1, 1, -1}, Cube{0, 1, -1}, Cube{1, 1, -1},
		Cube{-1, -1, 0}, Cube{0, -1, 0}, Cube{1, -1, 0},
		Cube{-1, 0, 0}, Cube{1, 0, 0},
		Cube{-1, 1, 0}, Cube{0, 1, 0}, Cube{1, 1, 0},
		Cube{-1, -1, 1}, Cube{0, -1, 1}, Cube{1, -1, 1},
		Cube{-1, 0, 1}, Cube{0, 0, 1}, Cube{1, 0, 1},
		Cube{-1, 1, 1}, Cube{0, 1, 1}, Cube{1, 1, 1},
	}, Cube{0, 0, 0}.Neighbours())
	assert.EqualValues(t, []Cube{
		Cube{-1, -1, -1, -1}, Cube{0, -1, -1, -1}, Cube{1, -1, -1, -1},
		Cube{-1, 0, -1, -1}, Cube{0, 0, -1, -1}, Cube{1, 0, -1, -1},
		Cube{-1, 1, -1, -1}, Cube{0, 1, -1, -1}, Cube{1, 1, -1, -1},
		Cube{-1, -1, 0, -1}, Cube{0, -1, 0, -1}, Cube{1, -1, 0, -1},
		Cube{-1, 0, 0, -1}, Cube{0, 0, 0, -1}, Cube{1, 0, 0, -1},
		Cube{-1, 1, 0, -1}, Cube{0, 1, 0, -1}, Cube{1, 1, 0, -1},
		Cube{-1, -1, 1, -1}, Cube{0, -1, 1, -1}, Cube{1, -1, 1, -1},
		Cube{-1, 0, 1, -1}, Cube{0, 0, 1, -1}, Cube{1, 0, 1, -1},
		Cube{-1, 1, 1, -1}, Cube{0, 1, 1, -1}, Cube{1, 1, 1, -1},

		Cube{-1, -1, -1, 0}, Cube{0, -1, -1, 0}, Cube{1, -1, -1, 0},
		Cube{-1, 0, -1, 0}, Cube{0, 0, -1, 0}, Cube{1, 0, -1, 0},
		Cube{-1, 1, -1, 0}, Cube{0, 1, -1, 0}, Cube{1, 1, -1, 0},
		Cube{-1, -1, 0, 0}, Cube{0, -1, 0, 0}, Cube{1, -1, 0, 0},
		Cube{-1, 0, 0, 0}, Cube{1, 0, 0, 0},
		Cube{-1, 1, 0, 0}, Cube{0, 1, 0, 0}, Cube{1, 1, 0, 0},
		Cube{-1, -1, 1, 0}, Cube{0, -1, 1, 0}, Cube{1, -1, 1, 0},
		Cube{-1, 0, 1, 0}, Cube{0, 0, 1, 0}, Cube{1, 0, 1, 0},
		Cube{-1, 1, 1, 0}, Cube{0, 1, 1, 0}, Cube{1, 1, 1, 0},

		Cube{-1, -1, -1, 1}, Cube{0, -1, -1, 1}, Cube{1, -1, -1, 1},
		Cube{-1, 0, -1, 1}, Cube{0, 0, -1, 1}, Cube{1, 0, -1, 1},
		Cube{-1, 1, -1, 1}, Cube{0, 1, -1, 1}, Cube{1, 1, -1, 1},
		Cube{-1, -1, 0, 1}, Cube{0, -1, 0, 1}, Cube{1, -1, 0, 1},
		Cube{-1, 0, 0, 1}, Cube{0, 0, 0, 1}, Cube{1, 0, 0, 1},
		Cube{-1, 1, 0, 1}, Cube{0, 1, 0, 1}, Cube{1, 1, 0, 1},
		Cube{-1, -1, 1, 1}, Cube{0, -1, 1, 1}, Cube{1, -1, 1, 1},
		Cube{-1, 0, 1, 1}, Cube{0, 0, 1, 1}, Cube{1, 0, 1, 1},
		Cube{-1, 1, 1, 1}, Cube{0, 1, 1, 1}, Cube{1, 1, 1, 1},
	}, Cube{0, 0, 0, 0}.Neighbours())
}

func TestAdd(t *testing.T) {
	assert.Equal(t, Cube{1, 2, 3}, Cube{0, 0, 0}.Add(Cube{1, 2, 3}))
	assert.Equal(t, Cube{1, 2, 3, 4}, Cube{0, 0, 0, 0}.Add(Cube{1, 2, 3, 4}))
	assert.Equal(t,
		Cube{-1, -2, -3}, Cube{0, 0, 0}.Add(Cube{-1, -2, -3}))
	assert.Equal(t,
		Cube{-1, -2, -3, -4}, Cube{0, 0, 0, 0}.Add(Cube{-1, -2, -3, -4}))
}

func TestGet(t *testing.T) {
	m := NewMap(ReadLines("test0.txt"), 3)
	assert.Equal(t, true, m.Get(Cube{0, 0, 0}))
	assert.Equal(t, true, m.Get(Cube{1, 0, 0}))
	assert.Equal(t, false, m.Get(Cube{0, 1, 0}))
	assert.Equal(t, true, m.Get(Cube{1, 1, 0}))

	m = NewMap(ReadLines("test1.txt"), 3)
	assert.Equal(t, true, m.Get(Cube{1, 0, 0}))
	assert.Equal(t, true, m.Get(Cube{2, 1, 0}))
	assert.Equal(t, true, m.Get(Cube{0, 2, 0}))
	assert.Equal(t, true, m.Get(Cube{1, 2, 0}))
	assert.Equal(t, true, m.Get(Cube{2, 2, 0}))

	m = NewMap(ReadLines("test0.txt"), 4)
	assert.Equal(t, true, m.Get(Cube{0, 0, 0, 0}))
	assert.Equal(t, true, m.Get(Cube{1, 0, 0, 0}))
	assert.Equal(t, false, m.Get(Cube{0, 1, 0, 0}))
	assert.Equal(t, true, m.Get(Cube{1, 1, 0, 0}))

	m = NewMap(ReadLines("test1.txt"), 4)
	assert.Equal(t, true, m.Get(Cube{1, 0, 0, 0}))
	assert.Equal(t, true, m.Get(Cube{2, 1, 0, 0}))
	assert.Equal(t, true, m.Get(Cube{0, 2, 0, 0}))
	assert.Equal(t, true, m.Get(Cube{1, 2, 0, 0}))
	assert.Equal(t, true, m.Get(Cube{2, 2, 0, 0}))
}

func TestAllNeighbours(t *testing.T) {
	m := NewMap([]string{"#"}, 3)
	assert.Equal(t, []Cube{Cube{0, 0, 0},
		Cube{-1, -1, -1}, Cube{0, -1, -1}, Cube{1, -1, -1},
		Cube{-1, 0, -1}, Cube{0, 0, -1}, Cube{1, 0, -1},
		Cube{-1, 1, -1}, Cube{0, 1, -1}, Cube{1, 1, -1},
		Cube{-1, -1, 0}, Cube{0, -1, 0}, Cube{1, -1, 0},
		Cube{-1, 0, 0}, Cube{1, 0, 0},
		Cube{-1, 1, 0}, Cube{0, 1, 0}, Cube{1, 1, 0},
		Cube{-1, -1, 1}, Cube{0, -1, 1}, Cube{1, -1, 1},
		Cube{-1, 0, 1}, Cube{0, 0, 1}, Cube{1, 0, 1},
		Cube{-1, 1, 1}, Cube{0, 1, 1}, Cube{1, 1, 1},
	}, m.AllNeighbours())

	//m = NewMap(ReadLines("test0.txt"), 3)
	//assert.Equal(t, []Cube{}, m.AllNeighbours())

	//mt := NewMap(ReadLines("test1.txt"), 3)
	//assert.Equal(t, []Cube{}, mt.AllNeighbours())
}

type IterTestCase struct {
	file string
	dim  int
	iter int
	ans  int
}

func TestIter(t *testing.T) {
	tests := []IterTestCase{
		{"test0.txt", 3, 1, 12},
		{"test0.txt", 3, 2, 4},
		{"test0.txt", 3, 3, 0},

		{"test1.txt", 3, 1, 11},
		{"test1.txt", 3, 2, 21},
		{"test1.txt", 3, 3, 38},
		{"test1.txt", 4, 1, 29},
		{"test1.txt", 4, 2, 60},
	}
	for _, tc := range tests {
		m := NewMap(ReadLines(tc.file), tc.dim)
		for i := 1; i < tc.iter; i++ {
			m.Iter()
		}
		assert.Equal(t, tc.ans, m.Iter(),
			fmt.Sprintf("file=%s dim=%d iter=%d", tc.file, tc.dim, tc.iter))
	}
}

type CalcTestCase struct {
	file string
	dim  int
	ans  int
}

func TestCalc(t *testing.T) {
	tests := []CalcTestCase{
		{"test1.txt", 3, 112},
		{"input.txt", 3, 209},
		{"test1.txt", 4, 848},
		{"input.txt", 4, 1492},
		//slow//{"test1.txt", 5, 5760},
		//slow//{"input.txt", 5, 11408},
	}
	for _, tc := range tests {
		m := NewMap(ReadLines(tc.file), tc.dim)
		assert.Equal(t, tc.ans, m.Calc(),
			fmt.Sprintf("%s %d", tc.file, tc.dim))
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
