package main

import (
	_ "embed"
	"fmt"
	"math"
	//"strings"

	"github.com/beanz/advent/lib-go/intcode"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func tryPhase(p []int64, phase []int) int64 {
	u := make([]*intcode.IntCode, len(phase))
	for i := 0; i < len(phase); i++ {
		u[i] = intcode.NewIntCode(p, []int64{int64(phase[i])})
	}
	done := 0
	var last, out int64
	first := true
	for done != len(phase) {
		done = 0
		for i := 0; i < len(phase); i++ {
			ic := u[i]
			if ic.Done() {
				done++
				first = false
				continue
			}
			//fmt.Printf("Running unit %d: %v\n", i, u[i])
			if !first {
				ic.In(out)
			}
			rc := ic.Run()
			o := ic.Out(1)
			if len(o) == 1 {
				out = o[0]
				last = o[0]
				//fmt.Printf("unit %d gave output %d\n", i, out)
			}
			if rc == intcode.Finished || rc == intcode.FinishedOpError {
				//fmt.Printf("unit %d halted %d\n", i, rc)
				done++
			}
			first = false
		}
	}
	return last
}

func run(p []int64, minPhase int, maxPhase int) int64 {
	perm := Permutations(minPhase, maxPhase)
	var max int64 = math.MinInt64
	for _, v := range perm {
		thrust := tryPhase(p, v)
		if max < thrust {
			max = thrust
		}
	}
	return max
}

func part1(p []int64) int64 {
	return run(p, 0, 4)
}

func part2(p []int64) int64 {
	return run(p, 5, 9)
}

func main() {
	p := FastInt64s(InputBytes(input), 4096)
	p1 := part1(p)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := part2(p)
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
