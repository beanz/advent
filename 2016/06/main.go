package main

import (
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
	"strings"
)

//go:embed input.txt
var input []byte

type Comms struct {
	bc []ByteCounter
}

func NewComms(in []byte) *Comms {
	c := &Comms{make([]ByteCounter, 0, 16)}
	var i int
	w := 0
FIRST:
	for ; i < len(in); i++ {
		switch in[i] {
		case '\n':
			w = i + 1
			break FIRST
		default:
			c.bc = append(c.bc, NewSliceByteCounter(26))
			c.bc[i].Inc(in[i])
		}
	}
	i++
	for ; i < len(in); i++ {
		switch in[i] {
		case '\n':
			continue
		default:
			c.bc[i%w].Inc(in[i])
		}
	}
	return c
}

func (c *Comms) String() string {
	var sb strings.Builder
	for i := 0; i < len(c.bc); i++ {
		fmt.Fprintf(&sb, "%d: %s\n", i, c.bc[i])
	}
	return sb.String()
}

func (c *Comms) Part1() string {
	var sb strings.Builder
	for i := 0; i < len(c.bc); i++ {
		sb.WriteByte(c.bc[i].Top(1)[0])
	}
	return sb.String()
}

func (c *Comms) Part2() string {
	var sb strings.Builder
	for i := 0; i < len(c.bc); i++ {
		sb.WriteByte(c.bc[i].Bottom(1)[0])
	}
	return sb.String()
}

func main() {
	comms := NewComms(InputBytes(input))
	p1 := comms.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %s\n", p1)
	}
	p2 := comms.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %s\n", p2)
	}
}

var benchmark = false
