package main

import (
	_ "embed"
	"fmt"
	"math"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Int = int32
type Occupied [76800]bool

func OccupiedIndex(x, y Int) Int {
	return (x-300)*192 + y
}

func (o *Occupied) Add(x, y Int) {
	o[OccupiedIndex(x, y)] = true
}

func (o *Occupied) Empty(x, y Int) bool {
	return !o[OccupiedIndex(x, y)]
}

func Debug(m *Occupied, minx, maxx, maxy Int) {
	for y := Int(0); y <= maxy; y++ {
		for x := minx; x <= maxx; x++ {
			if !m.Empty(x, y) {
				fmt.Print(string('#'))
			} else {
				fmt.Print(".")
			}
		}
		fmt.Println()
	}
}

func Parts(in []byte) (int, int) {
	minx, maxx, maxy := int32(math.MaxInt32), int32(math.MinInt32), int32(math.MinInt32)
	m := Occupied{}
	for i := 0; i < len(in); i++ {
		j, x := ChompUInt[int32](in, i)
		i = j + 1
		j, y := ChompUInt[int32](in, i)
		i = j
		m.Add(x, y)
		if minx > x {
			minx = x
		}
		if maxx < x {
			maxx = x
		}
		if maxy < y {
			maxy = y
		}
		for i < len(in) && in[i] != '\n' {
			i += 4
			j, nx := ChompUInt[int32](in, i)
			i = j + 1
			j, ny := ChompUInt[int32](in, i)
			i = j
			var ix Int
			if nx > x {
				ix = 1
			} else if nx < x {
				ix = -1
			}
			var iy Int
			if ny > y {
				iy = 1
			} else if ny < y {
				iy = -1
			}
			for x != nx || y != ny {
				x += ix
				y += iy
				if minx > x {
					minx = x
				}
				if maxx < x {
					maxx = x
				}
				if maxy < y {
					maxy = y
				}
				m.Add(x, y)
			}
		}
	}
	//Debug(&m, minx, maxx, maxy)
	p1 := 0
	c := 0
	var sx int32 = 500
	var sy int32
	for {
		if p1 == 0 && (sx > maxx || sx < minx) {
			p1 = c
		}
		if sy < maxy+1 {
			if m.Empty(sx, sy+1) {
				sy++
				continue
			}
			if m.Empty(sx-1, sy+1) {
				sx--
				sy++
				continue
			}
			if m.Empty(sx+1, sy+1) {
				sx++
				sy++
				continue
			}
		}
		m.Add(sx, sy)
		c++
		if sx == 500 && sy == 0 {
			break
		}
		sx = 500
		sy = 0
	}
	return p1, c
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
