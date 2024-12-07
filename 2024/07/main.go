package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func sums(nums []int, i, sub, total int, p2 bool) bool {
	if i == len(nums) {
		return sub == total
	}
	if sums(nums, i+1, sub+nums[i], total, p2) {
		return true
	}
	if sums(nums, i+1, sub*nums[i], total, p2) {
		return true
	}
	if !p2 {
		return false
	}
	for t := nums[i]; t > 0; sub, t = sub*10, t/10 {
	}
	sub += nums[i]
	return sums(nums, i+1, sub, total, p2)
}

func Parts(in []byte, args ...int) (int, int) {
	p1, p2 := 0, 0
	nums := []int{}
	for i := 0; i < len(in); {
		j, total := ChompUInt[int](in, i)
		i = j + 2
		for in[i] != '\n' {
			var n int
			i, n = ChompUInt[int](in, i)
			nums = append(nums, n)
			i++
			if in[i-1] == '\n' {
				break
			}
		}
		if sums(nums, 1, nums[0], total, false) {
			p1 += total
			p2 += total
			nums = nums[:0]
			continue
		}
		if sums(nums, 1, nums[0], total, true) {
			p2 += total
		}
		nums = nums[:0]
	}
	return p1, p2
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
