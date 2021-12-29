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

func (g *Game) Dragon(size int) []bool {
	n := make([]bool, len(g.input), 5*size/2)
	copy(n, g.input)
	for len(n) < size {
		l := len(n)
		n = append(n, false)
		for i := l - 1; i >= 0; i-- {
			n = append(n, !n[i])
		}
	}
	return n[:size]
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

func (g *Game) Play(l int) string {
	data := g.Dragon(l)
	return Checksum(data)
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
