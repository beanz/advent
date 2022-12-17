package main

import (
	_ "embed"
	"fmt"
	"sort"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Sensor struct {
	x, y     int
	bx, by   int
	md       int
	r1x, r1y int
	r2x, r2y int
}

func rotCCW(x, y int) (int, int) {
	return x + y, y - x
}

func rotCW(x, y int) (int, int) {
	return (x - y) >> 1, (y + x) >> 1
}

type Pos struct {
	x, y int
}

type Span struct {
	s, e int
}

type ByStart []Span

func (bs ByStart) Len() int { return len(bs) }

func (bs ByStart) Less(i, j int) bool { return bs[i].s < bs[j].s }

func (bs ByStart) Swap(i, j int) { bs[i], bs[j] = bs[j], bs[i] }

func SpansForRow(s []Sensor, y int) []Span {
	spans := [30]Span{}
	k := 0
	for _, sensor := range s {
		d := sensor.md - Abs(sensor.y-y)
		if d < 0 {
			continue
		}
		spans[k].s, spans[k].e = sensor.x-d, sensor.x+d+1
		k++
	}
	sort.Sort(ByStart(spans[:k]))
	j := 0
	for i := 1; i < k; i++ {
		if spans[i].s <= spans[j].e {
			if spans[i].e > spans[j].e {
				spans[j].e = spans[i].e
			}
			continue
		}
		j++
		spans[j] = spans[i]
	}
	return spans[:j+1]
}

func Parts(in []byte) (int, int) {
	sensors := [30]Sensor{}
	k := 0
	for i := 0; i < len(in); {
		j, x := NextInt(in, i+12)
		j, y := NextInt(in, j+4)
		j, bx := NextInt(in, j+25)
		j, by := NextInt(in, j+4)
		d := Abs(x-bx) + Abs(y-by)
		r1x, r1y := rotCCW(x-d-1, y)
		r2x, r2y := rotCCW(x+d+1, y)
		sensors[k] = Sensor{x, y, bx, by, d, r1x, r1y, r2x, r2y}
		k++
		i = j + 1
	}
	y := 2000000
	max := 4000000
	if k < 15 {
		y = 10 // example
		max = 20
	}
	return Part1(sensors[:k], y), Part2(sensors[:k], max)
}

func Part1(sensors []Sensor, y int) int {
	done := make(map[int]struct{}, 30)
	for _, s := range sensors {
		if s.by == y {
			done[s.bx] = struct{}{}
		}
	}
	beaconCount := len(done)
	spans := SpansForRow(sensors, y)
	p1 := -beaconCount
	for _, span := range spans {
		p1 += span.e - span.s
	}
	return p1
}

func Part2(sensors []Sensor, max int) int {
	nx := make([]int, 0, 30)
	ny := make([]int, 0, 30)
	for i := 0; i < len(sensors); i++ {
		for j := i; j < len(sensors); j++ {
			if sensors[i].r1x == sensors[j].r2x {
				nx = append(nx, sensors[i].r1x)
			}
			if sensors[i].r2x == sensors[j].r1x {
				nx = append(nx, sensors[i].r2x)
			}
			if sensors[i].r1y == sensors[j].r2y {
				ny = append(ny, sensors[i].r1y)
			}
			if sensors[i].r2y == sensors[j].r1y {
				ny = append(ny, sensors[i].r2y)
			}
		}
	}
	sort.Ints(nx)
	l := 1
	for i := 1; i < len(nx); i++ {
		if nx[i-1] != nx[i] {
			nx[l] = nx[i]
			l++
		}
	}
	nx = nx[:l]
	sort.Ints(ny)
	l = 1
	for i := 1; i < len(ny); i++ {
		if ny[i-1] != ny[i] {
			ny[l] = ny[i]
			l++
		}
	}
	ny = ny[:l]
	poss := make([]Pos, 0, 30)
	for _, rx := range nx {
		for _, ry := range ny {
			x, y := rotCW(rx, ry)
			if 0 <= x && x <= max && 0 <= y && y <= max {
				poss = append(poss, Pos{x, y})
			}
		}
	}
	if len(poss) == 1 {
		return 4000000*poss[0].x + poss[0].y
	}
	for _, p := range poss {
		near := false
		for _, sensor := range sensors {
			md := Abs(sensor.x-p.x) + Abs(sensor.y-p.y)
			if md <= sensor.md {
				near = true
				break
			}
		}
		if !near {
			return 4000000*p.x + p.y
		}
	}
	return 0
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

func NextInt(in []byte, i int) (j int, n int) {
	j = i
	m := 1
	if in[j] == '-' {
		m = -1
		j++
	}
	for ; '0' <= in[j] && in[j] <= '9'; j++ {
		n = 10*n + int(in[j]-'0')
	}
	n *= m
	return
}

var benchmark = false
