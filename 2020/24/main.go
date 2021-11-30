package main

import (
	"fmt"
	"log"
	"os"

	. "github.com/beanz/advent/lib-go"
)

type HexTile uint

func NewHexTile(q, r int8) HexTile {
	return HexTile((uint(int(q)+127) << 8) + uint(int(r)+127))
}

func (h HexTile) K() uint {
	return uint(h)
}

func (h HexTile) Q() int8 {
	return int8(int(h>>8) - 127)
}

func (h HexTile) R() int8 {
	return int8(int(h&0xff) - 127)
}

func NewHexTileFromString(moves string) HexTile {
	s := moves
	q := int8(0)
	r := int8(0)
	for len(s) > 0 {
		switch {
		case s[0] == 'e':
			s = s[1:]
			q++
		case s[0] == 'w':
			s = s[1:]
			q--
		case s[0:2] == "se":
			s = s[2:]
			r--
		case s[0:2] == "sw":
			s = s[2:]
			q--
			r--
		case s[0:2] == "nw":
			s = s[2:]
			r++
		case s[0:2] == "ne":
			s = s[2:]
			q++
			r++
		default:
			log.Fatalf("invalid hex tile moves: %s\n", s)
		}
	}
	return NewHexTile(q, r)
}

func HexTileNeighbourOffsets() {
	ht := NewHexTile(0, 0)
	q := ht.Q()
	r := ht.R()

	for _, n := range []HexTile{
		NewHexTile(q+1, r+0),
		NewHexTile(q+0, r-1),
		NewHexTile(q-1, r-1),
		NewHexTile(q-1, r+0),
		NewHexTile(q+0, r+1),
		NewHexTile(q+1, r+1)} {
		fmt.Printf("%d\n", int(ht)-int(n))
	}
}

type HexTiles map[HexTile]bool

type Game struct {
	init  HexTiles
	cur   *HexTiles
	debug bool
}

func NewGame(in []string) *Game {
	init := make(HexTiles)
	for _, l := range in {
		ht := NewHexTileFromString(l)
		if _, ok := init[ht]; ok {
			delete(init, ht)
		} else {
			init[ht] = true
		}
	}
	return &Game{init, nil, true}
}

func (g *Game) Part1() int {
	return len(g.init)
}

func (g *Game) Check(ht HexTile, done HexTiles) bool {
	if done[ht] {
		return false
	}
	nc := 0
	for _, no := range []int{-256, 1, 257, 256, -1, -257} {
		nt := HexTile(int(ht) + no)
		if _, ok := (*g.cur)[nt]; ok {
			nc++
		}
	}
	_, ok := (*g.cur)[ht]
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
	done := make(HexTiles)
	for ht := range *g.cur {
		if g.Check(ht, done) {
			next[ht] = true
		}
		for _, no := range []int{-256, 1, 257, 256, -1, -257} {
			nht := HexTile(int(ht) + no)
			if g.Check(nht, done) {
				next[nht] = true
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
	//HexTileNeighbourOffsets()
	fmt.Printf("Part 1: %d\n", g.Part1())
	fmt.Printf("Part 2: %d\n", g.Part2(100))
}
