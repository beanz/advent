package main

import (
	_ "embed"
	"fmt"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Scanner struct {
	beacons []FP3
	pos     *FP3
	rotated [][]FP3
}

type Game struct {
	scanners []*Scanner
	beacons  map[FP3]bool
}

func NewGame(in []byte) *Game {
	chunks := strings.Split(string(in), "\n\n")
	g := &Game{
		make([]*Scanner, 0, len(chunks)),
		make(map[FP3]bool, 512),
	}
	for _, ch := range chunks {
		s := strings.SplitN(ch, "\n", 2)
		ints := FastSignedInts([]byte(s[1]), 128)
		points := make([]FP3, 0, 32)
		for i := 0; i < len(ints); i += 3 {
			points = append(points,
				NewFP3(int16(ints[i]), int16(ints[i+1]), int16(ints[i+2])))
		}
		scanner := &Scanner{points, nil, make([][]FP3, 24)}
		for r := 0; r < 24; r++ {
			scanner.rotated[r] = make([]FP3, len(points))
			for i := 0; i < len(points); i++ {
				scanner.rotated[r][i] = points[i].Rotate(r)
			}
		}
		g.scanners = append(g.scanners, scanner)
	}
	for _, b := range g.scanners[0].beacons {
		g.beacons[b] = true
	}
	origin := NewFP3(0, 0, 0)
	g.scanners[0].pos = &origin
	return g
}

func (g *Game) align(i int) bool {
	//fmt.Printf("trying to align scanner %d\n", i)
	alloc := make([]FP3, 0, 32)
	for known := range g.beacons {
		//for _, known := range  g.scanners[0].beacons {
		for bi := range g.scanners[i].beacons {
			//fmt.Printf("assuming %s == [%d] %s\n", known, bi, beacon)
			for ri := 0; ri < 24; ri++ {
				rbeacon := g.scanners[i].rotated[ri][bi]
				//fmt.Printf("rotation %d *> %s\n", ri, rbeacon)
				transform := known.Sub(rbeacon)
				//fmt.Printf("transform %s\n", transform)
				c := 0
				nb := alloc[:0]
				for obi := range g.scanners[i].beacons {
					if obi == bi {
						continue
					}
					robeacon := g.scanners[i].rotated[ri][obi]
					trobeacon := robeacon.Add(transform)
					//fmt.Printf("ro=%s tro=%s\n", robeacon, trobeacon)
					if _, ok := g.beacons[trobeacon]; ok {
						//fmt.Printf("matched %s\n", trobeacon)
						c++
					} else {
						nb = append(nb, trobeacon)
					}
				}
				if c >= 11 {
					//fmt.Printf("found %d rotation %d %s\n",
					//    c, ri, transform)
					g.scanners[i].pos = &transform
					for _, b := range nb {
						g.beacons[b] = true
					}
					return true
				}
			}
		}
	}
	return false
}

func (g *Game) Solve() (int, int) {
	todo := len(g.scanners) - 1
	for todo > 0 {
		for i := 1; i < len(g.scanners); i++ {
			if g.scanners[i].pos != nil {
				continue
			}
			if g.align(i) {
				todo--
			}
		}
	}
	max := 0
	for i := 0; i < len(g.scanners); i++ {
		for j := i + 1; j < len(g.scanners); j++ {
			md := g.scanners[i].pos.ManhattanDistance(*g.scanners[j].pos)
			if md > max {
				max = md
			}
		}

	}
	return len(g.beacons), max
}

func main() {
	g := NewGame(InputBytes(input))
	p1, p2 := g.Solve()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
