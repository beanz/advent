package main

import (
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

type MoonField int

const (
	X MoonField = iota
	Y
	Z
	VX
	VY
	VZ
)

type Moon [6]int

func (m Moon) String() string {
	return fmt.Sprintf("pos=<x=%3d, y=%3d, z=%3d>, vel=<x=%3d, y=%3d, z=%3d>",
		m[X], m[Y], m[Z], m[VX], m[VY], m[VZ])
}

func (m Moon) TotalEnergy() int {
	return (Abs(m[X]) + Abs(m[Y]) + Abs(m[Z])) *
		(Abs(m[VX]) + Abs(m[VY]) + Abs(m[VZ]))
}

type Moons []*Moon

func (moons *Moons) String() string {
	s := ""
	for _, m := range *moons {
		s += m.String() + "\n"
	}
	return s
}

func NewMoons(lines []string) *Moons {
	moons := Moons{}
	for _, line := range lines {
		ints := SimpleReadInts(line)
		moons = append(moons, &Moon{ints[X], ints[Y], ints[Z], 0, 0, 0})
	}
	return &moons
}

func combinations(n, m int) [][]int {
	res := [][]int{}
	for i := 0; i < n; i++ {
		for j := i + 1; j < n; j++ {
			res = append(res, []int{i, j})
		}
	}
	return res
}

func (moons *Moons) Step() {
	for _, combination := range combinations(len(*moons), 2) {
		m1 := (*moons)[combination[0]]
		m2 := (*moons)[combination[1]]
		for _, axis := range []MoonField{X, Y, Z} {
			if m1[axis] > m2[axis] {
				m1[VX+axis]--
				m2[VX+axis]++
			} else if m1[axis] < m2[axis] {
				m1[VX+axis]++
				m2[VX+axis]--
			}

		}
	}
	for _, m := range *moons {
		for _, axis := range []MoonField{X, Y, Z} {
			m[axis] += m[VX+axis]
		}
	}
}

func (moons *Moons) Part1(steps int) int {
	//fmt.Printf("After 0 steps:\n%s\n", moons)
	for step := 1; step <= steps; step++ {
		moons.Step()
		//fmt.Printf("After %d steps:\n%s\n", step, moons)
	}
	s := 0
	for _, m := range *moons {
		s += m.TotalEnergy()
	}
	return s
}

func (moons *Moons) axis(a MoonField) string {
	s := ""
	for _, m := range *moons {
		s += fmt.Sprintf("%d:%d\n", m[a], m[VX+a])
	}
	return s
}

func (moons *Moons) Part2() int64 {
	cycle := []int64{-1, -1, -1}
	initialState := []string{}
	for _, axis := range []MoonField{X, Y, Z} {
		initialState = append(initialState, moons.axis(axis))
	}
	var steps int64 = 0
	for cycle[X] == -1 || cycle[Y] == -1 || cycle[Z] == -1 {
		steps++
		moons.Step()
		for _, axis := range []MoonField{X, Y, Z} {
			if cycle[axis] != -1 {
				// already cycle found
				continue
			}
			if initialState[axis] == moons.axis(axis) {
				// cycle found
				//fmt.Printf("Found %d cycle at %d\n", axis, steps)
				cycle[axis] = steps
			}
		}
	}
	return LCM(cycle[0], cycle[1], cycle[2])
}

func main() {
	lines := ReadInputLines()
	fmt.Printf("Part 1: %d\n", NewMoons(lines).Part1(1000))
	fmt.Printf("Part 2: %d\n", NewMoons(lines).Part2())
}
