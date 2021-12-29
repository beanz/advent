package main

import (
	_ "embed"
	"fmt"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Game struct {
	input []bool
}

func NewGame(in []byte) *Game {
	l := len(in)
	if in[l-1] == '\n' {
		l--
	}
	b := make([]bool, l)
	for i := 0; i < l; i++ {
		switch in[i] {
		case '1':
			b[i] = true
		}
	}
	return &Game{b}
}

func (g *Game) Bit(i int) bool {
	rep := i / (len(g.input) + 1)
	ri := i % (len(g.input) + 1)
	if ri == len(g.input) {
		return DragonBit(rep + 1)
	}
	if (rep % 2) == 1 {
		return !g.input[len(g.input)-ri-1]
	}
	return g.input[ri]
}

func (g *Game) Dragon(size int) []bool {
	n := make([]bool, size)
	l := len(g.input)
	l1 := l + 1
	for i := 0; i < size; i++ {
		rep := i / l1
		ri := i % l1
		if ri == len(g.input) {
			n[i] = DragonBit(rep + 1)
			continue
		}
		if (rep % 2) == 1 {
			n[i] = !g.input[l-ri-1]
		} else {
			n[i] = g.input[ri]
		}
	}
	return n
}

func DragonBit(i int) bool {
	// separator bits
	return (((i & -i) << 1) & i) != 0
}

func PrettyDragon(b []bool) string {
	var s strings.Builder
	for i := 0; i < len(b); i++ {
		if b[i] {
			s.WriteByte('1')
		} else {
			s.WriteByte('0')
		}
	}
	return s.String()
}

func Checksum(b []bool) string {
	for {
		if len(b)%2 == 1 {
			break
		}
		nl := len(b) / 2
		for i := 0; i < nl; i++ {
			b[i] = b[i*2] == b[1+i*2]
		}
		b = b[:nl]
	}
	return PrettyDragon(b)
}

func (g *Game) Checksum(l int) string {
	b := make([]bool, l/2)
	for i := 0; i < len(b); i++ {
		b[i] = g.Bit(i*2) == g.Bit(i*2+1)
	}
	return Checksum(b)
}

func (g *Game) Play(l int) string {
	return g.Checksum(l)
}

func main() {
	game := NewGame(InputBytes(input))
	res := game.Play(272)
	if !benchmark {
		fmt.Printf("Part 1: %s\n", res)
	}

	res = game.Play(35651584)
	if !benchmark {
		fmt.Printf("Part 2: %s\n", res)
	}
}

var benchmark = false
