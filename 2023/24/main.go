package main

import (
	_ "embed"
	"fmt"
	"math/big"
	"os"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

const (
	X int = iota
	Y
	Z
	VX
	VY
	VZ
)

func Parts(in []byte, args ...int) (int, int) {
	p := make([][6]int, 0, 300)
	for i := 0; i < len(in); i++ {
		h := [6]int{}
		k := 0
		VisitInts[int](in, '\n', &i, func(n int) {
			h[k] = n
			k++
		})
		p = append(p, h)
	}
	min, max := 200000000000000, 400000000000000
	if len(p) < 100 {
		min, max = 7, 27
	}
	p1 := 0
	for i := 0; i < len(p); i++ {
		for j := i + 1; j < len(p); j++ {
			if intersect(p[i], p[j], min, max) {
				p1++
			}
		}
	}

	p2 := 1
LOOP:
	for rv := -1000; rv <= 1000; rv++ {
		//an := make([][2]int, 0, 300)
		a := make([]*big.Int, 0, 300)
		n := make([]*big.Int, 0, 300)
		for i := 0; i < len(p); i++ {
			v := p[i][VX] + p[i][VY] + p[i][VZ]
			s := p[i][X] + p[i][Y] + p[i][Z]
			dv := Abs(v - rv)
			if dv == 0 {
				continue LOOP
			}
			fmt.Fprintf(os.Stderr, "%d,%d\n", s%dv, dv)
			a = append(a, big.NewInt(int64(Mod(s, dv))))
			n = append(n, big.NewInt(int64(dv)))
			//an = append(an, [2]int{Mod(s, dv), dv})
		}
		// r := ChineseRemainderTheorem[int](an)
		r, err := CRT(a, n)
		if err != nil {
			continue
		}
		p2 = int(r.Int64())
		break
	}

	return p1, p2
}

func intersect(p1, p2 [6]int, min, max int) bool {
	f1 := [6]float64{}
	f2 := [6]float64{}
	f1[X] = float64(p1[X])
	f1[VX] = float64(p1[VX])
	f1[Y] = float64(p1[Y])
	f1[VY] = float64(p1[VY])
	f2[X] = float64(p2[X])
	f2[VX] = float64(p2[VX])
	f2[Y] = float64(p2[Y])
	f2[VY] = float64(p2[VY])
	x1e, y1e := f1[X]+f1[VX], f1[Y]+f1[VY]
	x2e, y2e := f2[X]+f2[VX], f2[Y]+f2[VY]
	m1 := (y1e - f1[Y]) / (x1e - f1[X])
	m2 := (y2e - f2[Y]) / (x2e - f2[X])
	if m1 == m2 {
		return false
	}
	c1 := f1[Y] - m1*f1[X]
	c2 := f2[Y] - m2*f2[X]
	px := (c2 - c1) / (m1 - m2)
	py := m1*px + c1
	if !(float64(min) <= px && px <= float64(max)) {
		return false
	}
	if !(float64(min) <= py && py <= float64(max)) {
		return false
	}
	fut1 := (p1[VX] > 0 && px > f1[X]) || (p1[VX] < 0 && px < f1[X]) || (p1[VY] > 0 && py > f1[Y]) || (p1[VY] < 0 && py < f1[Y])
	if !fut1 {
		return false
	}
	fut2 := (p2[VX] > 0 && px > f2[X]) || (p2[VX] < 0 && px < f2[X]) || (p2[VY] > 0 && py > f2[Y]) || (p2[VY] < 0 && py < f2[Y])
	return fut2
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
