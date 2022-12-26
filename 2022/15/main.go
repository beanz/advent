package main

import (
	_ "embed"
	"fmt"
	"sort"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Int int32

type Sensor struct {
	x, y     Int
	md       Int
	r1x, r1y Int
	r2x, r2y Int
}

func rotCCW(x, y Int) (Int, Int) {
	return x + y, y - x
}

func rotCW(x, y Int) (Int, Int) {
	return (x - y) >> 1, (y + x) >> 1
}

type Pos struct {
	x, y Int
}

type Span struct {
	s, e Int
}

type ByStart []Span

func (bs ByStart) Len() int { return len(bs) }

func (bs ByStart) Less(i, j int) bool { return bs[i].s < bs[j].s }

func (bs ByStart) Swap(i, j int) { bs[i], bs[j] = bs[j], bs[i] }

func SpansForRow(s []Sensor, y Int) []Span {
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
	var testY Int = 2000000
	var max Int = 4000000
	if len(in) < 800 {
		testY = 10 // example
		max = 20
	}
	on_y_l := 0
	on_y := [4]Int{}
	sensors := [30]Sensor{}
	k := 0
	for i := 0; i < len(in); {
		j, x := ChompInt[Int](in, i+12)
		j, y := ChompInt[Int](in, j+4)
		j, bx := ChompInt[Int](in, j+25)
		j, by := ChompInt[Int](in, j+4)
		if by == testY {
			if on_y_l == 0 || on_y[on_y_l-1] != bx {
				on_y[on_y_l] = bx
				on_y_l++
			}
		}
		d := Abs(x-bx) + Abs(y-by)
		r1x, r1y := rotCCW(x-d-1, y)
		r2x, r2y := rotCCW(x+d+1, y)
		sensors[k] = Sensor{x, y, d, r1x, r1y, r2x, r2y}
		k++
		i = j + 1
	}
	spans := SpansForRow(sensors[:k], testY)
	p1 := -on_y_l
	for _, span := range spans {
		p1 += int(span.e - span.s)
	}
	return p1, Part2(sensors[:k], max)
}

func Part2(sensors []Sensor, max Int) int {
	nx := make([]Int, 0, 30)
	ny := make([]Int, 0, 30)
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
	sort.Slice(nx, func(i, j int) bool { return nx[i] < nx[j] })
	l := 1
	for i := 1; i < len(nx); i++ {
		if nx[i-1] != nx[i] {
			nx[l] = nx[i]
			l++
		}
	}
	nx = nx[:l]
	sort.Slice(ny, func(i, j int) bool { return ny[i] < ny[j] })
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
		return 4000000*int(poss[0].x) + int(poss[0].y)
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
			return 4000000*int(p.x) + int(p.y)
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

var benchmark = false
