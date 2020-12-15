package main

import (
	"fmt"
	"log"
	"os"

	. "github.com/beanz/advent-of-code-go"
)

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
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	ints := ReadIntsFromFile(os.Args[1])
	fmt.Printf("Part 1: %d\n", Part1(ints))
	fmt.Printf("Part 2: %d\n", Part2(ints))
}
