package main

import (
	_ "embed"
	"fmt"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

const BIG = 811589153

func mod(n, m int) int {
	a := n % m
	if a < 0 {
		a += m
	}
	return a
}

func Pretty(nums []int, idx []int, key int) string {
	var sb strings.Builder
	for _, i := range idx {
		fmt.Fprintf(&sb, "%d, ", nums[i]*key)
	}
	s := sb.String()
	return s[:len(s)-2]
}

func Mix(nums []int, rounds int, key int) int {
	ln := len(nums)
	idx := make([]int, ln)
	for n := 0; n < ln; n++ {
		idx[n] = n
	}
	for r := 0; r < rounds; r++ {
		for i := 0; i < ln; i++ {
			num := nums[i] * key
			j := 0
			for ; idx[j] != i; j++ {
			}
			idx = append(idx[:j], idx[j+1:]...)
			n := mod(j+num, ln-1) // -1 because we've removed one
			idx = append(idx[:n], append([]int{i}, idx[n:]...)...)
			//fmt.Printf("  %s\n", Pretty(nums, idx, key))
		}
	}
	zero := 0
	for ; nums[zero] != 0; zero++ {
	}
	nZero := 0
	for ; idx[nZero] != zero; nZero++ {
	}
	return nums[idx[mod(nZero+1000, ln)]]*key + nums[idx[mod(nZero+2000, ln)]]*key + nums[idx[mod(nZero+3000, ln)]]*key
}

func Parts(in []byte) (int, int) {
	nums := make([]int, 0, 5000)
	nums2 := make([]int, 0, 5000)
	for i := 0; i < len(in); i++ {
		j, n := ChompInt[int](in, i)
		i = j
		nums = append(nums, n)
		nums2 = append(nums2, n)
	}
	return Mix(nums, 1, 1), Mix(nums2, 10, BIG)
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
