package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Board struct {
	b     [][]byte
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
	lookup map[byte][]*NumLocation
}

func NewHall(in []string) *Hall {
	calls := FastBytes([]byte(in[0]))
	in = in[1:]
	h := &Hall{
		calls:  calls,
		boards: make([]*Board, len(in)),
		left:   byte(len(in)),
		lookup: make(map[byte][]*NumLocation, 128),
	}
	for i, bin := range in {
		nums := FastBytes([]byte(bin))
		rows := make([][]byte, 5)
		rleft := make([]byte, 5)
		cleft := make([]byte, 5)
		h.boards[i] = &Board{rows, 0, false, byte(i), rleft, cleft}
		var r byte
		for ; r < 5; r++ {
			rleft[r] = 5
			cleft[r] = 5 // *sorry, not sorry*
			row := make([]byte, 5)
			var c byte
			for ; c < 5; c++ {
				n := nums[r*5+c]
				row[c] = n
				h.boards[i].score += int(n)
				h.AddLookup(n, &NumLocation{byte(i), r, c})
			}
			rows[r] = row
		}
	}
	return h
}

func (h *Hall) AddLookup(call byte, nl *NumLocation) {
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
				break
			}
		}
	}
	return p1, p2
}

func main() {
	inp := InputChunks(input)
	g := NewHall(inp)
	p1, p2 := g.Bingo()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
