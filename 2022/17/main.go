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
	rows []byte
	w    int
}

var ROCKS = [...]Rock{
	{[]byte{0b1111000}, 4},
	{[]byte{0b0100000, 0b1110000, 0b0100000}, 3},
	{[]byte{0b1110000, 0b0010000, 0b0010000}, 3},
	{[]byte{0b1000000, 0b1000000, 0b1000000, 0b1000000}, 1},
	{[]byte{0b1100000, 0b1100000}, 2},
}

type Chamber struct {
	m             []byte
	top           int
	jets          []byte
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

func (ch *Chamber) Rock() int {
	r := ch.rock_i
	ch.rock_i++
	if ch.rock_i == len(ROCKS) {
		ch.rock_i = 0
	}
	return r
}

func (ch Chamber) Hit(rn int, x, y int) bool {
	rows := ROCKS[rn].rows
	for i := 0; i < len(rows); i++ {
		if ch.m[y+i]&(rows[i]>>x) != 0 {
			return true
		}
	}
	return false
}

func (ch *Chamber) Fall() {
	rn := ch.Rock()
	p := Pos{2, ch.top + 3}
	for {
		if ch.Jet() == '<' {
			if p.x > 0 && !ch.Hit(rn, p.x-1, p.y) {
				p.x--
			}
		} else {
			if p.x < 7-ROCKS[rn].w && !ch.Hit(rn, p.x+1, p.y) {
				p.x++
			}
		}
		if !ch.Hit(rn, p.x, p.y-1) {
			p.y--
		} else {
			break
		}
	}
	rows := ROCKS[rn].rows
	for i := 0; i < len(rows); i++ {
		ch.m[p.y+i] |= rows[i] >> p.x
	}
	if ch.top < p.y+len(rows) {
		ch.top = p.y + len(rows)
	}
}

func (ch Chamber) String() string {
	bottom := 0
	if ch.top-5 > bottom {
		bottom = ch.top - 5
	}
	var sb strings.Builder
	for y := ch.top; y >= bottom; y-- {
		var bit byte = 0b1000000
		for bit > 0 {
			if ch.m[y]&bit != 0 {
				fmt.Fprintf(&sb, "%c", '#')
			} else {
				fmt.Fprintf(&sb, "%c", '.')
			}
			bit >>= 1
		}
		fmt.Fprintln(&sb)
	}
	return sb.String()
}

func (ch Chamber) Key() uint64 {
	var k uint64
	y := ch.top
	k = uint64(ch.m[y])
	k <<= 8
	k += uint64(ch.m[y-1])
	k <<= 8
	k += uint64(ch.m[y-2])
	k <<= 8
	k += uint64(ch.m[y-3])
	k <<= 8
	k += uint64(ch.m[y-4])
	k <<= 16
	k += uint64(ch.jet_i*8 + ch.rock_i)
	return k
}

type CycleState struct {
	round uint64
	top   int
}

func Parts(in []byte) (int, uint64) {
	m := [6400]byte{}
	m[0] = 0b1111111
	ch := Chamber{
		m:    m[0:],
		top:  1,
		jets: in[:len(in)-1],
	}
	round := uint64(1)
	last := uint64(1000000000000)
	seen := make(map[uint64]CycleState, 4096)
	var cycleTop uint64
	p1 := 0
	for round <= 5 {
		ch.Fall()
		round++
	}
	for round <= last {
		ch.Fall()
		if round == 2022 {
			p1 = ch.top - 1
		}
		if cycleTop == 0 {
			k := ch.Key()
			if round >= 2022 {
				if old, ok := seen[k]; ok {
					// fmt.Printf("found cycle: %d && %d / %d && %d\n",
					//   round, old.round, ch.top, old.top)
					diffTop := ch.top - old.top
					diffRound := round - old.round
					n := (last - round) / diffRound
					round += n * diffRound
					cycleTop = n * uint64(diffTop)
				}
			}
			seen[k] = CycleState{round, ch.top}
		}
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
