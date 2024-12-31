package aoc

import (
	"testing"
)

func Test_ListOfLists(t *testing.T) {
	b := [5 * 5]int{}
	lol := NewListOfLists(b[:], 5)
	for i := 0; i < 5; i++ {
		lol.Push(i, i*4+1)
		lol.Push(i, i*4+2)
		lol.Push(i, i*4+3)
		lol.Push(i, i*4+4)
	}
	for i := 0; i < 5; i++ {
		if lol.Len(i) != 4 {
			t.Fatalf("lol.Len(%d) should be %d; got %d", i, 4, lol.Len(i))
		}
		j := 1
		for v := range lol.Items(i) {
			if v != i*4+j {
				t.Fatalf("%d,%d: expected %d; got %d", i, j, i*4+j, v)
			}
			j++
		}
	}
	for i := 0; i < 5; i++ {
		for j := 0; j < 4; j++ {
			v := lol.Get(i, j)
			if v != i*4+j+1 {
				t.Fatalf("%d,%d: expected %d; got %d", i, j, i*4+j+1, v)
			}
		}
	}
}

func Test_ListOfListsOverflow(t *testing.T) {
	b := [5 * 5]int{}
	lol := NewListOfLists(b[:], 5)
	lol.Push(0, 1)
	lol.Push(0, 2)
	lol.Push(0, 3)
	lol.Push(0, 4)

	defer func() {
		if r := recover(); r == nil {
			t.Errorf("expected panic on overflow")
		}
	}()
	lol.Push(0, 5)
}
