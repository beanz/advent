package main

import (
	_ "embed"
	"crypto/md5"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Game struct {
	doorID string
	ns     *NumStr
	debug  bool
}

func (g *Game) String() string {
	return fmt.Sprintf("Door ID: %s\n", g.doorID)
}

func readGame(line string) *Game {
	return &Game{line, NewNumStr(line), false}
}

func (g *Game) reset() {
	g.ns = NewNumStr(g.doorID)
}

func (g *Game) nextPassword() string {
	p := ""
	for i := 0; i < 8; i++ {
		p += string(g.nextCharacter())
	}
	return p
}

func (g *Game) nextSum() string {
	var sum string
	for {
		sum = fmt.Sprintf("%x", md5.Sum(g.ns.Bytes()))
		g.ns.Inc()
		if sum[0] == '0' && sum[1] == '0' && sum[2] == '0' && sum[3] == '0' &&
			sum[4] == '0' {
			break
		}
	}
	return sum
}

func (g *Game) nextCharacter() rune {
	return rune(g.nextSum()[5])
}

func (g *Game) Part1() string {
	return g.nextPassword()
}

func (g *Game) nextStrongPassword() string {
	pass := []rune{'_', '_', '_', '_', '_', '_', '_', '_'}
	var s string
	for {
		sum := g.nextSum()
		pos := byte(sum[5]) - 48
		if pos > 7 || pos < 0 {
			continue
		}
		if pass[pos] != '_' {
			continue
		}
		pass[pos] = rune(sum[6])
		s = ""
		finished := true
		for _, r := range pass {
			s += string(r)
			if r == '_' {
				finished = false
			}
		}
		if finished {
			break
		}
		//fmt.Printf("%s %d %s %s\n", sum, pos, string(rune(sum[6])), s)
	}
	return s
}

func (g *Game) Part2() string {
	g.reset()
	return g.nextStrongPassword()
}

func main() {
	game := readGame(InputLines(input)[0])

	res := game.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %s\n", res)
	}

	res = game.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %s\n", res)
	}
}

var benchmark = false
