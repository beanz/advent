package main

import (
	_ "embed"
	"fmt"

	intcode "github.com/beanz/advent/lib-go/intcode"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Run(prog []int64, in int64) int64 {
	ic := intcode.NewIntCode(prog, []int64{in})
	ic.RunToHalt()
	out := ic.Out(-1)
	return out[len(out)-1]
}

func Part1(prog []int64) int64 {
	return Run(prog, 1);
}

func Part2(prog []int64) int64 {
	return Run(prog, 5);
}

func main() {
	p := FastInt64s(InputBytes(input), 4096)
	p1 := Part1(p)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p = FastInt64s(InputBytes(input), 4096)
	p2 := Part2(p)
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
