package main

import (
	_ "embed"
	"fmt"
	"math/big"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type ShuffleKind int

const (
	ShuffleDeal ShuffleKind = iota
	ShuffleCut
	ShuffleDealInc
)

type Shuffle struct {
	kind ShuffleKind
	num  *big.Int
}

func NewShuffle(line string) *Shuffle {
	ints := SimpleReadInts(line)
	if strings.HasPrefix(line, "cut") {
		return &Shuffle{ShuffleCut, big.NewInt(int64(ints[0]))}
	} else if strings.HasPrefix(line, "deal with") {
		return &Shuffle{ShuffleDealInc, big.NewInt(int64(ints[0]))}
	} else if strings.HasPrefix(line, "deal into") {
		return &Shuffle{ShuffleDeal, nil}
	}
	panic("unsupported shuffle")
}

func (s *Shuffle) Params(
	a *big.Int, b *big.Int, numCards *big.Int) (*big.Int, *big.Int) {
	var na *big.Int
	var nb *big.Int
	switch s.kind {
	case ShuffleDeal:
		na = new(big.Int).Neg(a)
		nb = new(big.Int).Sub(new(big.Int).Neg(b), big.NewInt(1))
	case ShuffleCut:
		na = a
		nb = new(big.Int).Sub(b, s.num)
	default:
		na = new(big.Int).Mul(a, s.num)
		nb = new(big.Int).Mul(b, s.num)
	}
	return new(big.Int).Mod(na, numCards), new(big.Int).Mod(nb, numCards)
}

func (s *Shuffle) ReverseParams(
	a *big.Int, b *big.Int, numCards *big.Int) (*big.Int, *big.Int) {
	var na *big.Int
	var nb *big.Int
	switch s.kind {
	case ShuffleDeal:
		na = new(big.Int).Neg(a)
		nb = new(big.Int).Sub(new(big.Int).Neg(b), big.NewInt(1))
	case ShuffleCut:
		na = a
		nb = new(big.Int).Add(b, s.num)
	default:
		m := new(big.Int).ModInverse(s.num, numCards)
		na = new(big.Int).Mul(a, m)
		nb = new(big.Int).Mul(b, m)
	}
	return new(big.Int).Mod(na, numCards), new(big.Int).Mod(nb, numCards)
}

type Game struct {
	shuffles []*Shuffle
	cards    *big.Int
}

func NewGame(lines []string, cards int64) *Game {
	shuffles := []*Shuffle{}
	for _, line := range lines {
		shuffles = append(shuffles, NewShuffle(line))
	}
	return &Game{shuffles, big.NewInt(cards)}
}

func (g *Game) Params(numCards *big.Int, reverse bool) (*big.Int, *big.Int) {
	a := big.NewInt(1)
	b := big.NewInt(0)
	for i, j := 0, len(g.shuffles)-1; j >= 0; i, j = i+1, j-1 {
		if reverse {
			a, b = g.shuffles[j].ReverseParams(a, b, numCards)
		} else {
			a, b = g.shuffles[i].Params(a, b, numCards)
		}
	}
	return a, b
}

func (g *Game) Forward(card int64) int64 {
	a, b := g.Params(g.cards, false)
	c := big.NewInt(card)
	return new(big.Int).Mod(
		new(big.Int).Add(
			new(big.Int).Mul(a, c),
			b),
		g.cards).Int64()
}

func (g *Game) Backward(card int64, rounds int64) int64 {
	a, b := g.Params(g.cards, true)
	// 1 round : a    * x + b
	// 2 rounds: a**2 * x + a*b + b
	// 2 rounds: a**3 * x + a**2 * b + a*b + b
	// ...
	//   roonds: a^rounds * x + (a^(rounds-1) + a^(rounds-2) + ... + 1) * b
	//           a^rounds * x + (       sum of geometric series       ) * b
	//           a^rounds * x + (       (a^rounds - 1) / (a - 1)      ) * b
	// [division is invmod just as in the deal with increment]
	aSub1 := new(big.Int).Sub(a, big.NewInt(1))
	cardBI := big.NewInt(card)
	times := big.NewInt(rounds)
	exp := new(big.Int).Exp(a, times, g.cards)
	expSub1 := new(big.Int).Sub(exp, big.NewInt(1))
	invmod := new(big.Int).ModInverse(aSub1, g.cards)
	return new(big.Int).Mod(
		new(big.Int).Add(
			new(big.Int).Mul(exp, cardBI),
			new(big.Int).Mul(b, new(big.Int).Mul(expSub1, invmod))),
		g.cards).Int64()
}

func main() {
	lines := InputLines(input)
	g1 := NewGame(lines, 10007)
	p1 := g1.Forward(2019)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	g2 := NewGame(lines, 119315717514047)
	p2 := g2.Backward(2020, 101741582076661)
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
