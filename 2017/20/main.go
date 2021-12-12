package main

import (
	_ "embed"
	"fmt"
	"math"
	"strings"
	"unicode"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Particle struct {
	p    Point3D
	v    Point3D
	a    Point3D
	dead bool
}

func (p *Particle) String() string {
	return fmt.Sprintf("%s v%s a%s dead=%t", p.p, p.v, p.a, p.dead)
}

func Position(p, v, a, t int) int {
	for i := 1; i <= t; i++ {
		v += a
		p += v
	}
	return p
}

func (p *Particle) Collision(o *Particle, t int) bool {
	y := Position(p.p.Y, p.v.Y, p.a.Y, t)
	oy := Position(o.p.Y, o.v.Y, o.a.Y, t)
	if y != oy {
		return false
	}
	z := Position(p.p.Z, p.v.Z, p.a.Z, t)
	oz := Position(o.p.Z, o.v.Z, o.a.Z, t)
	if z != oz {
		return false
	}
	x := Position(p.p.X, p.v.X, p.a.X, t)
	ox := Position(o.p.X, o.v.X, o.a.X, t)
	return x == ox
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
	minAccel := math.MaxInt64
	minA := []int{}
	origin := Point3D{0, 0, 0}
	for i, p := range g.particles {
		a := p.a.ManhattanDistance(origin)
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
	px := make([]int, len(g.particles))
	vx := make([]int, len(g.particles))
	for j, p := range g.particles {
		px[j] = p.p.X
		vx[j] = p.v.X
	}
	for t := 1; t < 10000; t++ {
		seen := make(map[int]*Particle, count)
		for j, p := range g.particles {
			if g.debug {
				fmt.Printf("%d %d: %s\n", t, j, p)
			}
			if p.dead {
				continue
			}
			vx[j] += p.a.X
			px[j] += vx[j]

			if cp, ok := seen[px[j]]; ok && p.Collision(cp, t) {
				if !cp.dead {
					cp.dead = true
					count--
				}
				p.dead = true
				count--
			}
			seen[px[j]] = p
		}
	}
	return count
}

func main() {
	lines := InputLines(input)
	p1 := NewGame(lines).Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := NewGame(lines).Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
