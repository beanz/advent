package main

import (
	_ "embed"
	"fmt"
	"math"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Min(x, y int) int {
	if x > y {
		return y
	}
	return x
}

func Steps(s []string) int {
	dirs := map[string]int{}
	for _, step := range s {
		dirs[step]++
	}
	m := Min(dirs["n"], dirs["s"])
	dirs["n"] -= m
	dirs["s"] -= m

	m = Min(dirs["ne"], dirs["sw"])
	dirs["ne"] -= m
	dirs["sw"] -= m

	m = Min(dirs["nw"], dirs["se"])
	dirs["nw"] -= m
	dirs["se"] -= m

	m = Min(dirs["nw"], dirs["ne"])
	dirs["nw"] -= m
	dirs["ne"] -= m
	dirs["n"] += m

	m = Min(dirs["sw"], dirs["se"])
	dirs["sw"] -= m
	dirs["se"] -= m
	dirs["s"] += m

	m = Min(dirs["ne"], dirs["s"])
	dirs["ne"] -= m
	dirs["s"] -= m
	dirs["se"] += m

	m = Min(dirs["nw"], dirs["s"])
	dirs["nw"] -= m
	dirs["s"] -= m
	dirs["sw"] += m

	m = Min(dirs["se"], dirs["n"])
	dirs["se"] -= m
	dirs["n"] -= m
	dirs["nw"] += m

	m = Min(dirs["sw"], dirs["n"])
	dirs["sw"] -= m
	dirs["n"] -= m
	dirs["nw"] += m

	sum := 0
	for _, v := range dirs {
		//fmt.Printf("%s: %d\n", k, v)
		sum += v
	}
	return sum
}

func Part1(s string) int {
	return Steps(strings.Split(s, ","))
}

func Part2(s string) int {
	steps := strings.Split(s, ",")
	max := math.MinInt64
	for i := 1; i < len(steps); i++ {
		s := Steps(steps[:i])
		if s > max {
			max = s
		}
	}
	return max
}

func main() {
	p1 := Part1(InputLines(input)[0])
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := Part2(InputLines(input)[0])
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
