package main

import (
	_ "embed"
	"fmt"
	"os"
	"sort"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	rules := make(map[int]bool, 2048)
	i := 0
	for i < len(in) {
		j, a := ChompUInt[int](in, i)
		j, b := ChompUInt[int](in, j+1)
		rules[(a<<16)+b] = true
		rules[(b<<16)+a] = false
		i = j + 1
		if in[i] == '\n' {
			i++
			break
		}
	}
	p1, p2 := 0, 0
	nums := make([]int, 0, 128)
	nums2 := make([]int, 0, 128)
	for i < len(in) {
		for i < len(in) {
			j, a := ChompUInt[int](in, i)
			i = j + 1
			nums = append(nums, a)
			nums2 = append(nums2, a)
			if in[j] == '\n' {
				break
			}
		}
		mid1 := nums[len(nums)/2]
		sort.Slice(nums, func(i, j int) bool {
			v, ok := rules[(nums[i]<<16)+nums[j]]
			if !ok {
				fmt.Fprintf(os.Stderr, "not found %d|%d %d\n", nums[j], nums[i],
					(nums[i]<<16)+nums[j])
				return true
			}
			return v
		})
		ok := true
		for i, a := range nums {
			if a != nums2[i] {
				ok = false
				break
			}
		}

		if ok {
			p1 += mid1
		} else {
			p2 += nums[len(nums)/2]
		}
		nums = nums[:0]
		nums2 = nums2[:0]
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
