package main

import (
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

type Board struct {
	b [][]int
	score int
	won bool
	num int
	rleft []int
	cleft []int
}

type NumLocation struct {
	b, r, c int
}

type Hall struct {
	calls []int
	boards []*Board
	left int
	lookup map[int][]*NumLocation
}

func NewHall(in []string) *Hall {
	calls := Ints(in[0])
	in = in[1:]
	h := &Hall{
		calls: calls,
		boards: make([]*Board, len(in)),
		left: len(in),
		lookup: make(map[int][]*NumLocation),
	}
	for i, bin := range in {
		nums := Ints(bin)
		rows := make([][]int, 5)
		rleft := make([]int, 5)
		cleft := make([]int, 5)
		h.boards[i] = &Board{rows, 0, false, i, rleft, cleft}
		for r := 0; r < 5; r++ {
			rleft[r] = 5
			cleft[r] = 5 // *sorry, not sorry*
			row := make([]int, 5)
			for c := 0; c < 5; c++ {
				n := nums[r*5 + c]
				row[c] = n
				h.boards[i].score += n
				h.AddLookup(n, &NumLocation{i, r, c})
			}
			rows[r] = row
		}
	}
	return h
}

func (h *Hall) AddLookup(call int, nl *NumLocation) {
	if _, ok := h.lookup[call]; !ok {
		h.lookup[call] = []*NumLocation{}
	}
	h.lookup[call] = append(h.lookup[call], nl)
}

func (h *Hall) Bingo() (int, int) {
	p1, p2 := -1, -2
	first := true
	for _, call := range h.calls {
		for _, nl := range h.lookup[call] {
			board := h.boards[nl.b]
			if board.won {
				continue // already won so ignore
			}
			board.score -= call
			board.rleft[nl.r]--
			board.cleft[nl.c]--
			if board.rleft[nl.r] != 0 && board.cleft[nl.c] != 0 {
				continue // no row or col completed
			}
			board.won = true
			if first {
				first = false
				p1 = call * board.score
			}
			h.left--
			if h.left == 0 {
				p2 = call * board.score
				break
			}
		}
	}
	return p1, p2
}

func main() {
	inp := ReadInputChunks()
	g := NewHall(inp)
	p1, p2 := g.Bingo()
	fmt.Printf("Part 1: %d\n", p1)
	fmt.Printf("Part 2: %d\n", p2)
}
