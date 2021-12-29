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
	ring      [][16]byte
	stretched bool
}

func NewGame(salt []byte, stretched bool) *Game {
	if salt[len(salt)-1] == '\n' {
		salt = salt[:len(salt)-1]
	}
	ring := make([][16]byte, 1001)
	g := &Game{salt, 0, NewNumStrFromBytes(salt), ring, stretched}
	for i := 0; i < 1001; i++ {
		ring[i] = g.NextMD5()
	}
	return g
}

func (g *Game) String() string {
	return fmt.Sprintf("Salt: %s Index: %d\n", string(g.salt), g.index)
}

func (g *Game) NextMD5() [16]byte {
	sum := md5.Sum(g.numstr.Bytes())
	if g.stretched {
		b := make([]byte, 32)
		for i := 0; i < 2016; i++ {
			for j := 0; j < 16; j++ {
				b[j*2] = IntToHex((sum[j] & 0xf0) >> 4)
				b[1+j*2] = IntToHex(sum[j] & 0xf)
			}
			sum = md5.Sum(b)
		}
	}
	g.numstr.Inc()
	return sum
}

func TripleDigit(s []byte) (byte, bool) {
	a := (s[0] & 0xf0) >> 4
	b := s[0] & 0x0f
	for i := 1; i < len(s); i++ {
		c := (s[i] & 0xf0) >> 4
		d := s[i] & 0x0f
		if b == c && (a == b || b == d) {
			return b, true
		}
		a, b = c, d
	}
	return 0, false
}

func IntToHex(d byte) byte {
	if d > 9 {
		return 'a' + d - 10
	}
	return '0' + d
}

func HasFive(s []byte, d byte) bool {
	d0 := d << 4
	dd := d | d0
	for i := 0; i < len(s)-2; i++ {
		if s[i+1] != dd {
			continue
		}
		if s[i] == dd && s[i+2]&0xf0 == d0 {
			return true
		}
		if s[i]&0xf == d && s[i+2] == dd {
			return true
		}
	}
	return false
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
	var sum [16]byte
	for {
		ti := g.index
		sum = g.ring[ti%1001]
		g.ring[ti%1001] = g.NextMD5()
		g.index++
		ch, found := TripleDigit(sum[:16])
		if !found {
			continue
		}
		for i := 1; i < 1001; i++ {
			sum = g.ring[(ti+i)%1001]
			if HasFive(sum[:16], ch) {
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
