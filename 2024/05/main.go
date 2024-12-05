package main

import (
	_ "embed"
	"fmt"
	"slices"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	rules := make(map[int]struct{}, 2048)
	i := 0
	for i < len(in) {
		j, a := ChompUInt[int](in, i)
		j, b := ChompUInt[int](in, j+1)
		rules[(a<<16)+b] = struct{}{}
		i = j + 1
		if in[i] == '\n' {
			i++
			break
		}
	}
	p1, p2 := 0, 0
	nums := make([]int, 0, 128)
	for i < len(in) {
		for i < len(in) {
			j, a := ChompUInt[int](in, i)
			i = j + 1
			nums = append(nums, a)
			if in[j] == '\n' {
				break
			}
		}
		mid1 := nums[len(nums)/2]
		var changed bool
		slices.SortFunc(nums, func(a, b int) int {
			if _, ok := rules[(a<<16)+b]; ok {
				changed = true
				return -1
			} else {
				return 1
			}
		})
		if !changed {
			p1 += mid1
		} else {
			p2 += nums[len(nums)/2]
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
