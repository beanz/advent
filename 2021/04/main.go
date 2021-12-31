package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Board struct {
	score int
	won   bool
	num   byte
	rleft []byte
	cleft []byte
}

type NumLocation struct {
	b, r, c byte
}

type Hall struct {
	calls  []byte
	boards []*Board
	left   byte
	lookup [][]*NumLocation
}

func NewHall(in []byte) *Hall {
	i := 0
	for ; in[i] != '\n'; i++ {
	}
	calls := FastBytes([]byte(in[:i]))
	boardNums := FastBytes([]byte(in[i+1:]))
	numBoards := len(boardNums) / 25
	h := &Hall{
		calls:  calls,
		boards: make([]*Board, numBoards),
		left:   byte(numBoards),
		lookup: make([][]*NumLocation, 0, 100),
	}
	for n := 0; n < 100; n++ {
		h.lookup = append(h.lookup, make([]*NumLocation, 0, numBoards))
	}
	for i := 0; i < numBoards; i++ {
		nums := boardNums[i*25 : (i+1)*25]
		rleft := make([]byte, 5)
		cleft := make([]byte, 5)
		h.boards[i] = &Board{0, false, byte(i), rleft, cleft}
		var r byte
		for ; r < 5; r++ {
			rleft[r] = 5
			cleft[r] = 5 // *sorry, not sorry*
			var c byte
			for ; c < 5; c++ {
				n := nums[r*5+c]
				h.boards[i].score += int(n)
				h.lookup[n] = append(h.lookup[n], &NumLocation{byte(i), r, c})
			}
		}
	}
	return h
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
			board.score -= int(call)
			board.rleft[nl.r]--
			board.cleft[nl.c]--
			if board.rleft[nl.r] != 0 && board.cleft[nl.c] != 0 {
				continue // no row or col completed
			}
			board.won = true
			if first {
				first = false
				p1 = int(call) * board.score
			}
			h.left--
			if h.left == 0 {
				p2 = int(call) * board.score
				return p1, p2
			}
		}
	}
	return p1, p2
}

func main() {
	g := NewHall(InputBytes(input))
	p1, p2 := g.Bingo()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
