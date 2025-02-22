package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Calc(nums []int, maxTurn int) int {
	lastSeen := make([]int, maxTurn)
	n := 0
	p := 0
	for t := 1; t <= len(nums); t++ {
		n = nums[t-1]
		//if DEBUG() {
		//	fmt.Printf("%d: %d\n", t, n)
		//}
		if t > 1 {
			lastSeen[p] = t
		}
		p = n
	}
	for t := len(nums) + 1; t <= maxTurn; t++ {
		if lastSeen[p] > 0 {
			n = t - lastSeen[p]
		} else {
			n = 0
		}
		//if DEBUG() {
		//	fmt.Printf("%d: %d\n", t, n)
		//}
		lastSeen[p] = t
		p = n
	}
	if DEBUG() {
		fmt.Printf("len(lastSeen) = %d\n", len(lastSeen))
	}
	return n
}

func Part1(nums []int) int {
	return Calc(nums, 2020)
}

func Part2(nums []int) int {
	return Calc(nums, 30000000)
}

func main() {
	numbers := InputInts(input)
	p1 := Part1(numbers)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := Part2(numbers)
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
