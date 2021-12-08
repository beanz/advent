package main

import (
	"fmt"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

type Segments int

func NewSegments(s string) (res Segments) {
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
	switch s.String() {
	case "abcefg":
		return 0
	case "cf":
		return 1
	case "acdeg":
		return 2
	case "acdfg":
		return 3
	case "bcdf":
		return 4
	case "abdfg":
		return 5
	case "abdefg":
		return 6
	case "acf":
		return 7
	case "abcdefg":
		return 8
	case "abcdfg":
		return 9
	default:
		return -1
	}
}

type Entry struct {
	pattern      []Segments
	output       []Segments
	patternOfLen map[int][]Segments
	outputOfLen  map[int][]Segments
	line         string
	no           int
}

type Notes struct {
	entries []Entry
	debug   bool
}

func NewNotes(in []string) *Notes {
	entries := make([]Entry, 0, len(in))
	for i, l := range in {
		s := strings.Split(l, " | ")
		p := strings.Split(s[0], " ")
		o := strings.Split(s[1], " ")
		pl := make(map[int][]Segments)
		ps := make([]Segments, len(p))
		for i := range p {
			ps[i] = NewSegments(p[i])
			pl[len(p[i])] = append(pl[len(p[i])], ps[i])
		}
		ol := make(map[int][]Segments)
		os := make([]Segments, len(o))
		for i := range o {
			os[i] = NewSegments(o[i])
			ol[len(o[i])] = append(ol[len(o[i])], os[i])
		}
		entries = append(entries,
			Entry{
				pattern:      ps,
				patternOfLen: pl,
				output:       os,
				outputOfLen:  ol,
				line:         l,
				no:           i,
			})
	}
	return &Notes{entries, false}
}

func (n *Notes) Part1() int {
	c := 0
	for _, e := range n.entries {
		for l, v := range e.outputOfLen {
			if l == 2 || l == 3 || l == 4 || l == 7 {
				c += len(v)
			}
		}
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
	for _, e := range n.entries {
		sp := NewPerm(e)
		n := 0
		for _, w := range e.output {
			d := sp.Permute(w).Digit()
			if d == -1 {
				panic(fmt.Sprintf("%d %s: invalid digit %s", e.no, e.line, w))
			}
			n = n*10 + d
		}
		c += n
	}
	return c
}

func main() {
	inp := ReadInputLines()
	n := NewNotes(inp)
	fmt.Printf("Part 1: %d\n", n.Part1())
	fmt.Printf("Part 2: %d\n", n.Part2())
}
