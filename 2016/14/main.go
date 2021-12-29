package main

import (
	"crypto/md5"
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
	"strings"
)

//go:embed input.txt
var input []byte

type Game struct {
	salt      []byte
	index     int
	numstr    *NumStr
	ring      []string
	stretched bool
}

func NewGame(salt []byte, stretched bool) *Game {
	if salt[len(salt)-1] == '\n' {
		salt = salt[:len(salt)-1]
	}
	ring := make([]string, 1001)
	g := &Game{salt, 0, NewNumStrFromBytes(salt), ring, stretched}
	for i := 0; i < 1001; i++ {
		ring[i] = g.NextMD5()
	}
	return g
}

func (g *Game) String() string {
	return fmt.Sprintf("Salt: %s Index: %d\n", string(g.salt), g.index)
}

func (g *Game) NextMD5() string {
	sum := fmt.Sprintf("%x", md5.Sum(g.numstr.Bytes()))
	if g.stretched {
		for i := 0; i < 2016; i++ {
			sum = fmt.Sprintf("%x", md5.Sum([]byte(sum)))
		}
	}
	g.numstr.Inc()
	return sum
}

func Triple(s string) string {
	chars := []string{"0", "1", "2", "3", "4", "5", "6", "7", "8",
		"9", "a", "b", "c", "d", "e", "f"}
	best := 1000000
	res := ""
	for _, ch := range chars {
		triple := ch + ch + ch
		if i := strings.Index(s, triple); i != -1 {
			if i < best {
				res = ch
				best = i
			}
		}
	}
	return res
}

func (g *Game) NextKey() int {
	var sum string
	for {
		ti := g.index
		sum = g.ring[ti%1001]
		g.ring[ti%1001] = g.NextMD5()
		g.index++
		ch := Triple(sum)
		if ch == "" {
			continue
		}
		match := ch + ch + ch + ch + ch
		for i := 1; i < 1001; i++ {
			sum = g.ring[(ti+i)%1001]
			if strings.Contains(sum, match) {
				//fmt.Printf("Got a hit at index %d\n", ti)
				return ti
			}
		}
	}
}

func (g *Game) Play() int {
	var r int
	for i := 0; i < 64; i++ {
		r = g.NextKey()
	}
	return r
}

func main() {
	game := NewGame(InputBytes(input), false)
	res := game.Play()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", res)
	}

	game = NewGame(InputBytes(input), true)
	res = game.Play()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", res)
	}
}

var benchmark = false
