package main

import (
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
	"strings"
)

//go:embed input.txt
var input []byte

type Dir byte

const (
	Up Dir = iota
	Down
	Left
	Right
)

type Key byte

func (k Key) String() string {
	if k > 9 {
		return string('A' + byte(k-10))
	}
	return string('0' + byte(k))
}

type Pad struct {
	keys  byte
	moves [4][]Key
}

func (p *Pad) Next(k Key, d Dir) Key {
	return p.moves[byte(d)][byte(k)]
}

func PadOne() *Pad {
	var k byte = 9
	moves := [4][]Key{
		{0, 1, 2, 3, 1, 2, 3, 4, 5, 6},
		{0, 4, 5, 6, 7, 8, 9, 7, 8, 9},
		{0, 1, 1, 2, 4, 4, 5, 7, 7, 8},
		{0, 2, 3, 3, 5, 6, 6, 8, 9, 9},
	}
	return &Pad{k, moves}
}

func PadTwo() *Pad {
	var k byte = 13
	moves := [4][]Key{
		{0, 0x1, 0x2, 0x1, 0x4, 0x5, 0x2, 0x3, 0x4, 0x9, 0x6, 0x7, 0x8, 0xB},
		{0, 0x3, 0x6, 0x7, 0x8, 0x5, 0xA, 0xB, 0xC, 0x9, 0xA, 0xD, 0xC, 0xD},
		{0, 0x1, 0x2, 0x2, 0x3, 0x5, 0x5, 0x6, 0x7, 0x8, 0xA, 0xA, 0xB, 0xD},
		{0, 0x1, 0x3, 0x4, 0x4, 0x6, 0x7, 0x8, 0x9, 0x9, 0xB, 0xC, 0xC, 0xD},
	}
	return &Pad{k, moves}
}

func Decode(in []byte, p *Pad) string {
	var key Key = 5
	var sb strings.Builder
	for _, ch := range in {
		switch ch {
		case 'U':
			key = p.Next(key, Up)
		case 'D':
			key = p.Next(key, Down)
		case 'L':
			key = p.Next(key, Left)
		case 'R':
			key = p.Next(key, Right)
		case '\n':
			sb.WriteString(key.String())
		}
	}
	return sb.String()
}

func main() {
	p1 := Decode(InputBytes(input), PadOne())
	if !benchmark {
		fmt.Printf("Part 1: %s\n", p1)
	}
	p2 := Decode(InputBytes(input), PadTwo())
	if !benchmark {
		fmt.Printf("Part 2: %s\n", p2)
	}
}

var benchmark = false
