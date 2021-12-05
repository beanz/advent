package main

import (
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

func part1(prog []int) int {
	ic := []*IntCode{}
	for i := 0; i < 50; i++ {
		ic = append(ic, NewIntCode(prog, []int{i}))
	}
	for {
		for i := 0; i < 50; i++ {
			rc := ic[i].Run()
			if rc == 0 {
				out := ic[i].Out(3)
				if len(out) >= 3 {
					//fmt.Printf("recevied %v\n", out)
					addr := out[0]
					x := out[1]
					y := out[2]
					if addr == 255 {
						return y
					}
					if addr < 50 {
						ic[out[0]].In(x, y)
					}
				}
			} else if rc == 2 {
				ic[i].In(-1)
			}
		}
	}
}

func part2(prog []int) int {
	ic := []*IntCode{}
	for i := 0; i < 50; i++ {
		ic = append(ic, NewIntCode(prog, []int{i}))
	}
	natX := 0
	natY := 0
	lastY := -1
	for {
		idle := 0
		for i := 0; i < 50; i++ {
			rc := ic[i].Run()
			if rc == 0 {
				out := ic[i].Out(3)
				if len(out) >= 3 {
					// fmt.Printf("recevied %v\n", out)
					addr := out[0]
					x := out[1]
					y := out[2]
					if addr == 255 {
						natX = x
						natY = y
					}
					if addr < 50 {
						ic[out[0]].In(x, y)
					}
				}
			} else if rc == 2 {
				ic[i].In(-1)
				idle++
			}
		}
		if idle == 50 {
			if lastY == natY {
				return natY
			}
			lastY = natY
			ic[0].In(natX, natY)
		}
	}
}

func main() {
	lines := ReadInputLines()
	prog := SimpleReadInts(lines[0]) // TOFIX: needs int64
	fmt.Printf("Part 1: %d\n", part1(prog))
	fmt.Printf("Part 2: %d\n", part2(prog))
}
