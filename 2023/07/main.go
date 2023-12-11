package main

import (
	_ "embed"
	"fmt"
	"sort"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Score int

const (
	HighCard Score = iota
	OnePair
	TwoPair
	ThreeOfAKind
	FullHouse
	FourOfAKind
	FiveOfAKind
)

type hand struct {
	s1, s2, bid int
	hand        []byte
}

func Parts(in []byte) (int, int) {
	hands := make([]hand, 0, 1000)
	for i := 0; i < len(in); i++ {
		h := in[i : i+5]
		s1 := 0
		s2 := 0
		c := make(map[byte]byte, 5)
		var mc byte
		for j := i; j < i+5; j++ {
			c[in[j]]++
			if mc < c[in[j]] {
				mc = c[in[j]]
			}
			var cardScore int
			switch in[j] {
			case 'T':
				cardScore = 10
			case 'J':
				cardScore = 11
			case 'Q':
				cardScore = 12
			case 'K':
				cardScore = 13
			case 'A':
				cardScore = 14
			default:
				cardScore = int(in[j]) - '0'
			}
			s1 = (s1 << 4) + cardScore
			if cardScore == 11 {
				cardScore = 0
			}
			s2 = (s2 << 4) + cardScore
		}
		i += 6
		j, bid := ChompUInt[int](in, i)
		i = j
		var h1 Score
		switch len(c) {
		case 1:
			h1 = FiveOfAKind
		case 2:
			if mc == 4 {
				h1 = FourOfAKind
			} else {
				h1 = FullHouse
			}
		case 3:
			if mc == 3 {
				h1 = ThreeOfAKind
			} else {
				h1 = TwoPair
			}
		case 4:
			h1 = OnePair
		case 5:
			h1 = HighCard
		}
		h2 := h1
		switch c['J'] {
		case 1:
			switch mc {
			case 4:
				h2 = FiveOfAKind
			case 3:
				h2 = FourOfAKind
			case 2:
				switch len(c) {
				case 4:
					h2 = ThreeOfAKind
				case 3:
					h2 += 2
				default:
					h2 += 1
				}
			default:
				h2 += 1
			}
		case 2:
			switch len(c) {
			case 2:
				h2 = FiveOfAKind
			case 3:
				h2 = FourOfAKind
			default:
				h2 = ThreeOfAKind
			}
		case 3:
			h2 = h1 + 2
		case 4:
			h2 = h1 + 1
		}
		s1 += int(h1) << 20
		s2 += int(h2) << 20
		hands = append(hands, hand{s1, s2, bid, h})
	}
	sort.Slice(hands, func(i, j int) bool {
		return hands[i].s1 < hands[j].s1
	})
	p1 := 0
	for i := 0; i < len(hands); i++ {
		p1 += (i + 1) * hands[i].bid
	}
	sort.Slice(hands, func(i, j int) bool {
		return hands[i].s2 < hands[j].s2
	})
	p2 := 0
	for i := 0; i < len(hands); i++ {
		p2 += (i + 1) * hands[i].bid
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
