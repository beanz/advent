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
	x, y   int
	bx, by int
	md     int
}

type Span struct {
	s, e int
}

type ByStart []Span

func (bs ByStart) Len() int { return len(bs) }

func (bs ByStart) Less(i, j int) bool { return bs[i].s < bs[j].s }

func (bs ByStart) Swap(i, j int) { bs[i], bs[j] = bs[j], bs[i] }

func SpansForRow(s []Sensor, y int, spans []Span) int {
	k := 0
	for _, sensor := range s {
		d := sensor.md - Abs(sensor.y-y)
		if d < 0 {
			continue
		}
		spans[k] = Span{sensor.x - d, sensor.x + d + 1}
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
	return j + 1
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
		sensors[k] = Sensor{x, y, bx, by, d}
		k++
		i = j + 1
	}
	y := 2000000
	maxY := 4000000
	if k < 15 {
		y = 10 // example
		maxY = 20
	}
	done := make(map[int]struct{}, 30)
	for _, s := range sensors[:k] {
		if s.by == y {
			done[s.bx] = struct{}{}
		}
	}
	beaconCount := len(done)
	spans := [30]Span{}
	spanLen := SpansForRow(sensors[:k], y, spans[:30])
	p1 := -beaconCount
	for _, span := range spans[:spanLen] {
		p1 += span.e - span.s
	}
	p2 := -1
	mid := maxY / 2
	for iy := 0; iy < mid; iy++ {
		y := mid - iy - 1
		spanLen := SpansForRow(sensors[:k], y, spans[:30])
		if spanLen == 2 {
			p2 = 4000000*spans[0].e + y
			break
		}
		y = mid + iy
		spanLen = SpansForRow(sensors[:k], y, spans[:30])
		if spanLen == 2 {
			p2 = 4000000*spans[0].e + y
			break
		}
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
