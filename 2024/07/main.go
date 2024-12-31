package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func sums(nums []int, i, total int, p2 bool) bool {
	if i == 0 {
		return nums[i] == total
	}
	if total > nums[i] && sums(nums, i-1, total-nums[i], p2) {
		return true
	}
	if total%nums[i] == 0 && sums(nums, i-1, total/nums[i], p2) {
		return true
	}
	if !p2 {
		return false
	}
	m := 1000
	if nums[i] < 10 {
		m = 10
	} else if nums[i] < 100 {
		m = 100
	}
	return total%m == nums[i] && sums(nums, i-1, total/m, p2)
}

func Parts(in []byte, args ...int) (int, int) {
	p1, p2 := 0, 0
	nums := make([]int, 0, 16)
	for i := 0; i < len(in); {
		j, total := ChompUInt[int](in, i)
		i = j + 2
		VisitUints(in, '\n', &i, func(n int) {
			nums = append(nums, n)
		})
		i++
		if sums(nums, len(nums)-1, total, false) {
			p1 += total
			p2 += total
			nums = nums[:0]
			continue
		}
		if sums(nums, len(nums)-1, total, true) {
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
