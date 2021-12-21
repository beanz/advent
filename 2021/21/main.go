package main

import (
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Game struct {
	p1, p2 int
}

type D100 struct {
	d int
}

func NewD100() *D100 {
	return &D100{0}
}

func (d *D100) Roll() int {
	r := (d.d % 100) + 1
	d.d++
	return r
}

func (d *D100) Count() int {
	return d.d
}

func NewGame(in []byte) *Game {
	ints := FastInts(in, 4)
	return &Game{ints[1], ints[3]}
}

func (g *Game) Part1() int {
	s := []int{0, 0}
	p := []int{g.p1, g.p2}
	dice := NewD100()
	for {
		for i := 0; i < 2; i++ {
			r := dice.Roll() + dice.Roll() + dice.Roll()
			p[i] += r
			for p[i] > 10 {
				p[i] -= 10
			}
			s[i] += p[i]
			//fmt.Printf("Player %d moves to space %d for a total score of %d\n",
			//	i+1, p[i], s[i])
			if s[i] >= 1000 {
				return s[1-i] * dice.Count()
			}
		}
	}
}

type Counts struct {
	w1, w2 int64
}

type WinCounter struct {
	cache []*Counts
}

func NewWinCounter() *WinCounter {
	return &WinCounter{make([]*Counts, 262144)}
}

func (wc *WinCounter) Len() int {
	return len(wc.cache)
}

var rollWays = [][]int{{3, 1}, {4, 3}, {5, 6}, {6, 7}, {7, 6}, {8, 3}, {9, 1}}

func (wc *WinCounter) CountWins(pos1, score1, pos2, score2 int8) (int64, int64) {
	k := ((((int(pos1)<<5 + int(score1)) << 4) + int(pos2)) << 5) + int(score2)
	if v := wc.cache[k]; v != nil {
		return (*v).w1, (*v).w2
	}
	var w1, w2 int64
	for _, rw := range rollWays {
		roll, ways := rw[0], rw[1]
		np1 := pos1 + int8(roll)
		for np1 > 10 {
			np1 -= 10
		}
		ns1 := score1 + np1
		if ns1 >= 21 {
			w1 += int64(ways)
			continue
		}
		// reverse arguments pairs and reverse answers
		sw2, sw1 := wc.CountWins(pos2, score2, np1, ns1)
		w1 += sw1 * int64(ways)
		w2 += sw2 * int64(ways)
	}
	wc.cache[k] = &Counts{w1, w2}
	return w1, w2
}

func (g *Game) Part2() int64 {
	wc := NewWinCounter()
	w1, w2 := wc.CountWins(int8(g.p1), 0, int8(g.p2), 0)
	if w1 > w2 {
		return w1
	}
	return w2
}

func main() {
	g := NewGame(InputBytes(input))
	p1 := g.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := g.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
