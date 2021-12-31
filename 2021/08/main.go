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
}

type Notes struct {
	entries []Entry
	debug   bool
}

func NewNotes(in []byte) *Notes {
	entries := make([]Entry, 0, 200)
	pl := make(map[int][]Segments)
	ps := make([]Segments, 0, 10)
	ol := make(map[int][]Segments)
	os := make([]Segments, 0, 4)
	j := 0
	state := true // pattern part
	word := false
	for i := 0; i < len(in); i++ {
		if 'a' <= in[i] && in[i] <= 'g' {
			if !word {
				j = i
				word = true
			}
		} else if in[i] == ' ' {
			if word {
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
		} else if in[i] == '|' {
			state = false // output part
		} else if in[i] == '\n' {
			if word {
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
			entries = append(entries,
				Entry{
					pattern:      ps,
					patternOfLen: pl,
					output:       os,
					outputOfLen:  ol,
				})
			word = false
			pl = make(map[int][]Segments)
			ps = make([]Segments, 0, 10)
			ol = make(map[int][]Segments)
			os = make([]Segments, 0, 4)
			state = true // pattern part
		}
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
