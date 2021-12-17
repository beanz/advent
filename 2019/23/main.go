package main

import (
	_ "embed"
	"fmt"

	intcode "github.com/beanz/advent/lib-go/intcode"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func part1(prog []int64) int64 {
	ic := []*intcode.IntCode{}
	for i := 0 ; i < 50; i++ {
		ic = append(ic, intcode.NewIntCode(prog, []int64{int64(i)}))
	}
	for {
		for i := 0; i < 50; i++ {
			//fmt.Printf("i: %d\n", i)
			rc := ic[i].Run()
			//fmt.Printf("rc=%d\n", rc)
			if rc == intcode.ProducedOutput {
				out := ic[i].Out(3)
				if len(out) >= 3 {
					//fmt.Printf("received %v\n", out)
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
			} else if rc == intcode.NeedInput {
				ic[i].In(-1)
			}
		}
	}
}

func part2(prog []int64) int64 {
	ic := []*intcode.IntCode{}
	for i := 0 ; i < 50; i++ {
		ic = append(ic, intcode.NewIntCode(prog, []int64{int64(i)}))
	}
	var natX int64
	var natY int64
	var lastY int64 = -1
	for {
		idle := 0
		for i := 0; i < 50; i++ {
			rc := ic[i].Run()
			if rc == intcode.ProducedOutput {
				out := ic[i].Out(3)
				if len(out) >= 3 {
					//fmt.Printf("received %v\n", out)
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
			} else if rc == intcode.NeedInput {
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
	prog := FastInt64s(InputBytes(input), 4096)
	p1 := part1(prog)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := part2(prog)
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
