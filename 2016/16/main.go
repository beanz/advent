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
	input string
	size  int
	debug bool
}

func Dragon(s string, size int) string {
	var b strings.Builder
	b.WriteString(s)
	ps := s
	for {
		b.Grow(len(ps)*2 + 1)
		b.WriteRune('0')
		ch := strings.Split(ps, "")
		for i := len(ps) - 1; i >= 0; i-- {
			if ch[i] == "0" {
				b.WriteRune('1')
			} else {
				b.WriteRune('0')
			}
		}
		if b.Len() >= size {
			break
		}
		ps = b.String()
	}
	return b.String()[0:size]
}

func Checksum(s string) string {
	c := s
	for {
		if len(c)%2 == 1 {
			break
		}
		var b strings.Builder
		b.Grow(len(c) / 2)
		for i := 0; i < len(c); i += 2 {
			if c[i] == c[i+1] {
				b.WriteRune('1')
			} else {
				b.WriteRune('0')
			}
		}
		c = b.String()
	}
	return c
}

func (g *Game) DiscData() string {
	return Dragon(g.input, g.size)
}

func (g *Game) Play() string {
	data := g.DiscData()
	return Checksum(data)
}

func main() {
	in := InputLines(input)
	game := Game{in[0], 272, true}
	res := game.Play()
	if !benchmark {
		fmt.Printf("Part 1: %s\n", res)
	}

	game = Game{in[0], 35651584, true}
	res = game.Play()
	if !benchmark {
		fmt.Printf("Part 2: %s\n", res)
	}
}

var benchmark = false
