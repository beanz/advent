package main

import (
	"fmt"
	"log"
	"os"

	. "github.com/beanz/advent-of-code-go"
)

type HexTile struct {
	q, r int
}

func NewHexTile(q, r int) *HexTile {
	return &HexTile{q, r}
}

func (h *HexTile) K() string {
	return fmt.Sprintf("%d,%d", h.q, h.r)
}

func (h *HexTile) Q() int {
	return h.q
}

func (h *HexTile) R() int {
	return h.r
}

func (h *HexTile) Move(moves string) {
	s := moves
	for len(s) > 0 {
		switch {
		case s[0] == 'e':
			s = s[1:]
			h.q++
		case s[0] == 'w':
			s = s[1:]
			h.q--
		case s[0:2] == "se":
			s = s[2:]
			h.r--
		case s[0:2] == "sw":
			s = s[2:]
			h.q--
			h.r--
		case s[0:2] == "nw":
			s = s[2:]
			h.r++
		case s[0:2] == "ne":
			s = s[2:]
			h.q++
			h.r++
		default:
			log.Fatalf("invalid hex tile moves: %s\n", s)
		}
	}
}

func (h *HexTile) NB() []*HexTile {
	return []*HexTile{
		&HexTile{h.q + 1, h.r + 0},
		&HexTile{h.q + 0, h.r - 1},
		&HexTile{h.q - 1, h.r - 1},
		&HexTile{h.q - 1, h.r + 0},
		&HexTile{h.q + 0, h.r + 1},
		&HexTile{h.q + 1, h.r + 1},
	}
}

type HexTiles map[string]*HexTile

type Game struct {
	init  HexTiles
	cur   *HexTiles
	debug bool
}

func NewGame(in []string) *Game {
	init := make(HexTiles)
	for _, l := range in {
		ht := NewHexTile(0, 0)
		ht.Move(l)
		k := ht.K()
		if _, ok := init[k]; ok {
			delete(init, k)
		} else {
			init[k] = ht
		}
	}
	return &Game{init, nil, true}
}

func (g *Game) Part1() int {
	return len(g.init)
}

func (g *Game) Check(ht *HexTile, done map[string]bool) bool {
	if done[ht.K()] {
		return false
	}
	nc := 0
	for _, nt := range ht.NB() {
		if _, ok := (*g.cur)[nt.K()]; ok {
			nc++
		}
	}
	_, ok := (*g.cur)[ht.K()]
	if (ok && !(nc == 0 || nc > 2)) ||
		(!ok && nc == 2) {
		return true
	}
	return false
}

func (g *Game) Iter() int {
	if g.cur == nil {
		g.cur = &g.init
	}
	next := make(HexTiles)
	done := make(map[string]bool)
	for _, ht := range *g.cur {
		if g.Check(ht, done) {
			next[ht.K()] = ht
		}
		for _, nht := range ht.NB() {
			if g.Check(nht, done) {
				next[nht.K()] = nht
			}
		}
	}
	g.cur = &next
	return len(*g.cur)
}

func (g *Game) Part2(days int) int {
	c := 0
	for d := 1; d <= days; d++ {
		c = g.Iter()
	}
	return c
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}

	lines := ReadLines(os.Args[1])
	g := NewGame(lines)
	fmt.Printf("Part 1: %d\n", g.Part1())
	fmt.Printf("Part 2: %d\n", g.Part2(100))
}
