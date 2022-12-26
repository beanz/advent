package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Pkt struct {
	val  int
	list []Pkt
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

func Parts(in []byte) (int, int) {
	pkt2 := Pkt{list: []Pkt{{val: 2}}}
	pkt6 := Pkt{list: []Pkt{{val: 6}}}
	p1 := 0
	n := 1
	c2 := 1 // 1 indexed
	c6 := 2 // 1 indexed and pkt2 is before it
	for i := 0; i < len(in); {
		j, pktA := NextPkt(in, i)
		j, pktB := NextPkt(in, j+1)
		i = j + 2
		if Comp(pktA, pktB) == -1 {
			p1 += n
		}
		if Comp(pktA, pkt2) == -1 {
			c2++
			c6++
		} else if Comp(pktA, pkt6) == -1 {
			c6++
		}
		if Comp(pktB, pkt2) == -1 {
			c2++
			c6++
		} else if Comp(pktB, pkt6) == -1 {
			c6++
		}
		n++
	}
	return p1, c2 * c6
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
