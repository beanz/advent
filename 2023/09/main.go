package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	pascal := [22][22]int{}
	pascal[0][0] = 1
	pascal[1][0] = 1
	pascal[1][1] = 1
	for r := 2; r < 22; r++ {
		pascal[r][0] = 1
		for c := 1; c < r; c++ {
			pascal[r][c] = pascal[r-1][c-1] + pascal[r-1][c]
		}
		pascal[r][r] = 1
	}

	p1, p2 := 0, 0
	nums := make([]int, 0, 21)
	for i := 0; i < len(in); i++ {
		var n int
		for ; ; i++ {
			i, n = ChompInt[int](in, i)
			nums = append(nums, n)
			if in[i] == '\n' {
				break
			}
		}
		s1, s2 := Solve(pascal[len(nums)][:len(nums)+1], nums)
		p1 += s1
		p2 += s2
		nums = nums[:0]
	}
	return p1, p2
}

func Solve(pascal []int, nums []int) (int, int) {
	m := 1
	s1, s2 := 0, 0
	for i := 0; i < len(nums); i++ {
		tm := pascal[i+1] * m
		s1 += tm * nums[len(nums)-1-i]
		s2 += tm * nums[i]
		m *= -1
	}
	return s1, s2
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
