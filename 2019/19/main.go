package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Beam struct {
	prog   []int
	size   int
	mul    int
	ratio1 int
	ratio2 int
}

func NewBeam(p []int) *Beam {
	return &Beam{p, 100 - 1, 1, 1, 1}
}

func (b *Beam) inBeam(x int, y int) bool {
	ic := NewIntCode(b.prog, []int{x, y})
	return ic.RunToHalt()[0] == 1
}

func (b *Beam) part1() int {
	count := 0
	first := -1
	last := -1
	for y := 0; y < 50; y++ {
		first = -1
		last = -1
		for x := 0; x < 50; x++ {
			if b.inBeam(x, y) {
				if first == -1 {
					first = x
				}
				last = x
				count++
			}

		}
	}
	b.ratio1 = first
	b.ratio2 = last
	b.mul = 49
	return count
}

func (b *Beam) findRatios(y int) {
	first := 49
	for !b.inBeam(first, y) {
		first++
	}
	last := first
	for b.inBeam(last, y) {
		last++
	}
	b.ratio1 = first
	b.ratio2 = last
}

func (b *Beam) squareFits(x int, y int) bool {
	return b.inBeam(x, y) && b.inBeam(x+b.size, y) &&
		b.inBeam(x, y+b.size) // not necessary! && b.inBeam(x+99, y+99)
}

func (b *Beam) squareFitsY(y int) int {
	min := (y * b.ratio1 / b.mul)
	max := (y * b.ratio2 / b.mul)
	for x := min; x <= max; x++ {
		if b.squareFits(x, y) {
			return x
		}
	}
	return 0
}

func (b *Beam) part2() int {
	if b.ratio1 == -1 {
		b.findRatios(49)
	}
	upper := 1
	for b.squareFitsY(upper) == 0 {
		upper *= 2
		// fmt.Printf(" ^ %d\n", upper)
	}
	lower := upper / 2
	for {
		mid := lower + (upper-lower)/2
		if mid == lower {
			break
		}
		if b.squareFitsY(mid) > 0 {
			upper = mid
		} else {
			lower = mid
		}
		// fmt.Printf("%d ... %d\n", lower, upper)
	}

	var x int
	var y int
	for y = lower; y < lower+5; y++ {
		x = b.squareFitsY(y)
		if x > 0 {
			break
		}
	}
	return x*10000 + y
}

func main() {
	lines := InputLines(input)
	p := SimpleReadInts(lines[0])
	beam := NewBeam(p)
	p1 := beam.part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := beam.part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
