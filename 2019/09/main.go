package main

import (
	_ "embed"
	"fmt"
	"strings"

	"github.com/beanz/advent/lib-go/intcode"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func run(p []int64, input int64) string {
	ic := intcode.NewIntCode(p, []int64{input})
	for !ic.Done() {
		ic.Run()
	}
	var sb strings.Builder
	for _, v := range ic.Out(-1) {
		fmt.Fprintf(&sb, "%d,", v)
	}
	s := sb.String()
	return s[:len(s)-1]
}

func part1(p []int64) string {
	return run(p, 1)
}

func part2(p []int64) string {
	return run(p, 2)
}

func main() {
	p := FastInt64s(InputBytes(input), 4096)
	p1 := part1(p)
	if !benchmark {
		fmt.Printf("Part 1: %s\n", p1)
	}
	p2 := part2(p)
	if !benchmark {
		fmt.Printf("Part 2: %s\n", p2)
	}
}

var benchmark = false
