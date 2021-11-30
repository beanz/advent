package main

import (
	"fmt"
	"log"
	"math"
	"os"
	"strings"
	"unicode"

	. "github.com/beanz/advent/lib-go"
)

type Particle struct {
	p    Point3D
	v    Point3D
	a    Point3D
	dead bool
}

func (p *Particle) String() string {
	return fmt.Sprintf("%s v%s a%s dead=%t", p.p, p.v, p.a, p.dead)
}

type Game struct {
	particles []*Particle
	debug     bool
}

func (g *Game) String() string {
	return fmt.Sprintf("%d", len(g.particles))
}

func NewGame(lines []string) *Game {
	g := &Game{[]*Particle{}, false}
	for _, line := range lines {
		f := func(c rune) bool {
			return !(unicode.IsNumber(c) || c == '-')
		}
		values := ReadInts(strings.FieldsFunc(line, f))
		g.particles = append(g.particles,
			&Particle{Point3D{values[0], values[1], values[2]},
				Point3D{values[3], values[4], values[5]},
				Point3D{values[6], values[7], values[8]}, false})
	}
	return g
}

func (g *Game) Part1() int {
	minAccel := float64(math.MaxInt64)
	minA := []int{}
	for i, p := range g.particles {
		a := p.a.Size()
		if a < minAccel {
			minAccel = a
			minA = []int{i}
		} else if a == minAccel {
			minAccel = a
			minA = append(minA, i)
		}
	}
	if len(minA) == 1 {
		return minA[0]
	}
	return -1
}

func (g *Game) Part2() int {
	count := len(g.particles)
	for i := 0; i < 10000; i++ {
		seen := map[Point3D]*Particle{}
		for j, p := range g.particles {
			if g.debug {
				fmt.Printf("%d %d: %s\n", i, j, p)
			}
			if p.dead {
				continue
			}
			p.v.X += p.a.X
			p.v.Y += p.a.Y
			p.v.Z += p.a.Z
			p.p.X += p.v.X
			p.p.Y += p.v.Y
			p.p.Z += p.v.Z
			if cp, ok := seen[p.p]; ok {
				if !cp.dead {
					cp.dead = true
					count--
				}
				p.dead = true
				count--
			}
			seen[p.p] = p
		}
	}
	return count
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	fmt.Printf("Part 1: %d\n", NewGame(lines).Part1())
	fmt.Printf("Part 2: %d\n", NewGame(lines).Part2())
}
