package main

import (
	_ "embed"
	"fmt"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Stack []byte

func (s *Stack) Pick() byte {
	cr := (*s)[len(*s)-1]
	*s = (*s)[:len(*s)-1]
	return cr
}

func (s *Stack) Place(cr byte) {
	*s = append(*s, cr)
}

type Move struct {
	n, from, to int
}
type Game struct {
	st []Stack
	mv []Move
}

func (g *Game) String() string {
	var sb strings.Builder
	for _, s := range g.st {
		fmt.Fprintf(&sb, "C: %s\n", string(s))
	}
	//for _, m := range g.mv {
	//  fmt.Fprintf(&sb, "M: %d %d -> %d\n", m.n, m.from, m.to)
	//}
	return sb.String()
}

func (g *Game) Top() string {
	var sb strings.Builder
	for _, s := range g.st {
		if len(s) == 0 {
			continue
		}
		fmt.Fprintf(&sb, "%s", string(s[len(s)-1]))
	}
	return sb.String()
}

func NextUInt(in []byte, i int) (j int, n int) {
	j = i
	for ; '0' <= in[j] && in[j] <= '9'; j++ {
		n = 10*n + int(in[j]-'0')
	}
	return
}

func NewGame(in []byte) *Game {
	stacks := make([]Stack, 9)
	g := &Game{stacks, make([]Move, 0, 512)}
	i := 0
	j := 0
	st := make([][]byte, 9)
	for ; i < len(in); i++ {
		if in[i] == '\n' {
			if j == 0 {
				break
			}
			j = 0
			continue
		}
		j++
		if in[i] < 'A' || in[i] > 'Z' {
			continue
		}
		st[(j-1)/4] = append(st[(j-1)/4], in[i])
	}
	i++
	for ; i < len(in); i++ {
		j, n := NextUInt(in, i+5)
		from, to := int(in[j+6]-'0'), int(in[j+11]-'0')
		from--
		to--
		g.mv = append(g.mv, Move{n, from, to})
		i = j + 12
	}

	for i, s := range st {
		for j := len(s) - 1; j >= 0; j-- {
			stacks[i] = append(stacks[i], s[j])
		}
	}
	return g
}

func (g *Game) Part1() string {
	for _, mv := range g.mv {
		for i := 0; i < mv.n; i++ {
			cr := g.st[mv.from].Pick()
			g.st[mv.to].Place(cr)
		}
	}
	return g.Top()
}

func (g *Game) Part2() string {
	cr := make([]byte, 0, 100)
	for _, mv := range g.mv {
		for i := 0; i < mv.n; i++ {
			cr = append(cr, g.st[mv.from].Pick())
		}
		for j := len(cr) - 1; j >= 0; j-- {
			g.st[mv.to].Place(cr[j])
		}
		cr = cr[:0]
	}
	return g.Top()
}

func main() {
	in := InputBytes(input)
	p1 := NewGame(in).Part1()
	p2 := NewGame(in).Part2()
	if !benchmark {
		fmt.Printf("Part 1: %s\n", p1)
		fmt.Printf("Part 2: %s\n", p2)
	}
}

var benchmark = false
