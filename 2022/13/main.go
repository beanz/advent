package main

import (
	_ "embed"
	"fmt"
	"sort"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Pkt struct {
	val     int
	list    []Pkt
	special bool
}

func Comp(l Pkt, r Pkt) int {
	if l.list == nil && r.list == nil {
		if l.val < r.val {
			return -1
		} else if l.val > r.val {
			return 1
		} else {
			return 0
		}
	}
	if l.list != nil && r.list != nil {
		i := 0
		for ; i < len(l.list) && i < len(r.list); i++ {
			if cmp := Comp(l.list[i], r.list[i]); cmp != 0 {
				return cmp
			}
		}
		if len(l.list) < len(r.list) {
			return -1
		}
		if len(l.list) > len(r.list) {
			return 1
		}
		return 0
	}
	if r.list != nil {
		return Comp(Pkt{list: []Pkt{{val: l.val}}}, r)
	}
	return Comp(l, Pkt{list: []Pkt{{val: r.val}}})
}

func NextPkt(in []byte, i int) (int, Pkt) {
	if in[i] == '[' {
		i += 1
		pkt := Pkt{val: -1, list: make([]Pkt, 0, 5)}
		if in[i] == ']' {
			// empty list
		} else {
			for {
				j, subpkt := NextPkt(in, i)
				pkt.list = append(pkt.list, subpkt)
				i = j
				if in[i] == ']' {
					break
				}
				i++
			}
		}
		return i + 1, pkt
	}
	j, n := ChompOneOrTwoCharUInt[int](in, i)
	return j, Pkt{val: n, list: nil}
}

type Pkts []Pkt

func (p Pkts) Len() int           { return len(p) }
func (p Pkts) Swap(i, j int)      { p[i], p[j] = p[j], p[i] }
func (p Pkts) Less(i, j int) bool { return Comp(p[i], p[j]) == -1 }

func Parts(in []byte) (int, int) {
	pkt2 := Pkt{special: true, list: []Pkt{{val: 2}}}
	pkt6 := Pkt{special: true, list: []Pkt{{val: 6}}}
	pkts := make([]Pkt, 0, 300)
	pkts = append(pkts, pkt2, pkt6)
	for i := 0; i < len(in); i++ {
		if in[i] == '\n' {
			continue
		}
		j, pkt := NextPkt(in, i)
		i = j
		pkts = append(pkts, pkt)
	}
	p1 := 0
	for i := 2; i < len(pkts); i += 2 {
		if Comp(pkts[i], pkts[i+1]) == -1 {
			p1 += (i / 2)
		}
	}
	sort.Sort(Pkts(pkts))
	p2 := 1
	for i := 0; i < len(pkts); i++ {
		if pkts[i].special {
			p2 *= i + 1
		}
	}
	return p1, p2
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
