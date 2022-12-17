package main

import (
	_ "embed"
	"fmt"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Pos struct {
	x, y int
}

type Rock struct {
	points [5]Pos
	w, h   int
}

type Chamber struct {
	m             map[Pos]struct{}
	top           int
	jets          []byte
	rocks         [5]Rock
	jet_i, rock_i int
}

func (ch *Chamber) Jet() byte {
	j := ch.jets[ch.jet_i]
	ch.jet_i++
	if ch.jet_i == len(ch.jets) {
		ch.jet_i = 0
	}
	return j
}

func (ch *Chamber) Rock() *Rock {
	r := ch.rocks[ch.rock_i]
	ch.rock_i++
	if ch.rock_i == len(ch.rocks) {
		ch.rock_i = 0
	}
	return &r
}

func (ch Chamber) Hit(r *Rock, x, y int) bool {
	for _, p := range r.points {
		if _, ok := ch.m[Pos{x + p.x, y + p.y}]; ok {
			return true
		}
	}
	return false
}

func (ch *Chamber) Fall() {
	r := ch.Rock()
	p := Pos{2, ch.top + 3}
	for {
		if ch.Jet() == '<' {
			if p.x > 0 && !ch.Hit(r, p.x-1, p.y) {
				p.x--
			}
		} else {
			if p.x < 7-r.w && !ch.Hit(r, p.x+1, p.y) {
				p.x++
			}
		}
		if !ch.Hit(r, p.x, p.y-1) {
			p.y--
		} else {
			break
		}
	}
	for _, rp := range r.points {
		ch.m[Pos{p.x + rp.x, p.y + rp.y}] = struct{}{}
	}
	if ch.top < p.y+r.h {
		ch.top = p.y + r.h
	}
}

func (ch Chamber) String() string {
	bottom := 0
	if ch.top-5 > bottom {
		bottom = ch.top - 5
	}
	var sb strings.Builder
	for y := ch.top; y >= bottom; y-- {
		for x := 0; x < 7; x++ {
			if _, ok := ch.m[Pos{x, y}]; ok {
				fmt.Fprintf(&sb, "%c", '#')
			} else {
				fmt.Fprintf(&sb, "%c", '.')
			}
		}
		fmt.Fprintln(&sb)
	}
	return sb.String()
}

func (ch Chamber) Key() uint64 {
	var k uint64
	bit := uint64(1)
	for y := ch.top; y > ch.top-5; y-- {
		for x := 0; x < 7; x++ {
			if _, ok := ch.m[Pos{x, y}]; ok {
				k |= bit
			}
			bit <<= 1
		}
	}
	k <<= 14
	k |= uint64(ch.jet_i)
	k <<= 3
	k |= uint64(ch.rock_i)
	return k
}

type CycleState struct {
	round uint64
	top   int
}

func Parts(in []byte) (int, uint64) {
	m := map[Pos]struct{}{}
	for i := 0; i < 7; i++ { // create a floor
		m[Pos{i, 0}] = struct{}{}
	}
	ch := Chamber{
		m:    m,
		top:  1,
		jets: in[:len(in)-1],
		rocks: [5]Rock{
			Rock{[5]Pos{{0, 0}, {1, 0}, {2, 0}, {3, 0}, {0, 0}}, 4, 1},
			Rock{[5]Pos{{1, 2}, {0, 1}, {1, 1}, {2, 1}, {1, 0}}, 3, 3},
			Rock{[5]Pos{{2, 2}, {2, 1}, {0, 0}, {1, 0}, {2, 0}}, 3, 3},
			Rock{[5]Pos{{0, 3}, {0, 2}, {0, 1}, {0, 0}, {0, 0}}, 1, 4},
			Rock{[5]Pos{{0, 1}, {1, 1}, {0, 0}, {1, 0}, {0, 0}}, 2, 2},
		},
	}
	round := uint64(1)
	last := uint64(1000000000000)
	seen := map[uint64]CycleState{}
	var cycleTop uint64
	p1 := 0
	for round <= last {
		ch.Fall()
		if round == 2022 {
			p1 = ch.top - 1
		}
		k := ch.Key()
		if old, ok := seen[k]; ok && round >= 2022 && cycleTop == 0 {
			// fmt.Printf("found cycle: %d && %d / %d && %d\n",
			//   round, old.round, ch.top, old.top)
			diffTop := ch.top - old.top
			diffRound := round - old.round
			n := (last - round) / diffRound
			round += n * diffRound
			cycleTop = n * uint64(diffTop)
		}
		seen[k] = CycleState{round, ch.top}
		if round == 2022 {
			p1 = ch.top - 1
		}
		round++
	}
	return p1, cycleTop + uint64(ch.top-1)
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
