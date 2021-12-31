package main

import (
	_ "embed"
	"fmt"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Segments int

func NewSegments(s []byte) (res Segments) {
	for _, ch := range s {
		res |= (1 << (byte(ch) - byte('a')))
	}
	return
}

func (s Segments) String() string {
	var sb strings.Builder
	for i, bit := 0, 1; i < 7; i, bit = i+1, bit<<1 {
		if (int(s) & bit) != 0 {
			sb.WriteByte(byte('a') + byte(i))
		}
	}
	return sb.String()
}

func (s Segments) Digit() int {
	switch s {
	case 119: // 1+2+4+16+32+64
		return 0
	case 36: // 4+32
		return 1
	case 93: // 1+4+8+16+64
		return 2
	case 109: // 1+4+8+32+64
		return 3
	case 46: // 2+4+8+32
		return 4
	case 107: // 1 + 2 + 8 + 32 + 64
		return 5
	case 123: // 1+2+8+16+32+64
		return 6
	case 37: // 1+4+32
		return 7
	case 127: // 1+2+4+8+16+32+64
		return 8
	case 111: // 1+2+4+8+32+64
		return 9
	default:
		return -1
	}
}

type Entry struct {
	pattern      []Segments
	output       []Segments
	patternOfLen [][]Segments
	outputOfLen  [][]Segments
}

type Notes struct {
	entries []Entry
	debug   bool
}

func NewNotes(in []byte) *Notes {
	entries := make([]Entry, 0, 200)
	var pl [][]Segments
	var ps []Segments
	var ol [][]Segments
	var os []Segments

	prep := func() {
		pl = make([][]Segments, 8)
		pl[2] = make([]Segments, 0, 1)
		pl[3] = make([]Segments, 0, 1)
		pl[4] = make([]Segments, 0, 1)
		pl[7] = make([]Segments, 0, 1)
		pl[5] = make([]Segments, 0, 3)
		pl[6] = make([]Segments, 0, 3)
		ps = make([]Segments, 0, 10)
		ol = make([][]Segments, 8)
		ol[2] = make([]Segments, 0, 1)
		ol[3] = make([]Segments, 0, 1)
		ol[4] = make([]Segments, 0, 1)
		ol[7] = make([]Segments, 0, 1)
		ol[5] = make([]Segments, 0, 3)
		ol[6] = make([]Segments, 0, 3)
		os = make([]Segments, 0, 4)
	}
	j := 0
	state := true // pattern part
	word := false
	prepared := false

	addWord := func(i int) {
		if word {
			if !prepared {
				prep()
				prepared = true
			}
			s := NewSegments(in[j:i])
			l := i - j
			if state {
				ps = append(ps, s)
				pl[l] = append(pl[l], s)
			} else {
				os = append(os, s)
				ol[l] = append(ol[l], s)
			}
			word = false
		}
	}
	for i := 0; i < len(in); i++ {
		if 'a' <= in[i] && in[i] <= 'g' {
			if !word {
				j = i
				word = true
			}
		} else if in[i] == ' ' {
			addWord(i)
		} else if in[i] == '|' {
			state = false // output part
		} else if in[i] == '\n' {
			addWord(i)
			entries = append(entries,
				Entry{
					pattern:      ps,
					patternOfLen: pl,
					output:       os,
					outputOfLen:  ol,
				})
			word = false
			prepared = false
			state = true // pattern part
		}
	}
	return &Notes{entries, false}
}

func (n *Notes) Part1() int {
	c := 0
	for _, e := range n.entries {
		c += len(e.outputOfLen[2]) + len(e.outputOfLen[3]) +
			len(e.outputOfLen[4]) + len(e.outputOfLen[7])
	}
	return c
}

type SegmentPerm []Segments

func NewPerm(entry Entry) SegmentPerm {
	pl := entry.patternOfLen
	cf := pl[2][0]      // 1
	acf := pl[3][0]     // 7
	bcdf := pl[4][0]    // 4
	abcdefg := pl[7][0] // 8
	a := acf ^ cf
	abfg := pl[6][0] ^ pl[6][1] ^ pl[6][2]
	cde := abcdefg ^ abfg
	c := cde & cf
	f := cf ^ c
	bg := abfg ^ (f | a)
	b := bcdf & bg
	g := b ^ bg
	de := cde ^ c
	d := bcdf & de
	e := de ^ d
	return SegmentPerm([]Segments{a, b, c, d, e, f, g})
}

func (sp SegmentPerm) Permute(s Segments) Segments {
	res := 0
	for i, v := range sp {
		if (s & v) != 0 {
			res |= 1 << i
		}
	}
	return Segments(res)
}

func (sp SegmentPerm) String() string {
	var sb strings.Builder
	for i := 0; i < 7; i++ {
		sb.WriteString(sp[i].String())
		sb.WriteRune('>')
		sb.WriteByte(byte('a') + byte(i))
		if i == 6 {
			break
		}
		sb.WriteRune(' ')
	}
	return sb.String()
}

func (n *Notes) Part2() int {
	c := 0
	for i, e := range n.entries {
		sp := NewPerm(e)
		n := 0
		for _, w := range e.output {
			d := sp.Permute(w).Digit()
			if d == -1 {
				panic(fmt.Sprintf("invalid digit %s (%d)", w, i))
			}
			n = n*10 + d
		}
		c += n
	}
	return c
}

func main() {
	n := NewNotes(InputBytes(input))
	p1 := n.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := n.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
