package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Safe(nums []int) bool {
	diffs := make([]int, 0, len(nums)-1)
	for i := 1; i < len(nums); i++ {
		diffs = append(diffs, nums[i-1]-nums[i])
	}
	dec := 0
	inc := 0
	size := 0
	for _, d := range diffs {
		switch {
		case d < 0:
			inc++
			if d == -1 || d == -2 || d == -3 {
				size++
			}
		case d > 0:
			dec++
			if d == 1 || d == 2 || d == 3 {
				size++
			}
		}
	}
	l := len(diffs)
	return size == l && (dec == l || inc == l)
}

func Safe2(nums []int) bool {
	n := make([]int, 0, len(nums)-1)
	for i := 0; i < len(nums); i++ {
		for j, v := range nums {
			if i == j {
				continue
			}
			n = append(n, v)
		}
		if Safe(n) {
			return true
		}
		n = n[:0]
	}
	return false
}

func Parts(in []byte, args ...int) (int, int) {
	p1, p2 := 0, 0
	for i := 0; i < len(in); {
		l := []int{}
		for in[i] != '\n' {
			var n int
			i, n = ChompInt[int](in, i)
			l = append(l, n)
			if in[i] == '\n' {
				break
			}
			i++
		}
		if Safe(l) {
			p1++
			p2++
		} else if Safe2(l) {
			p2++
		}
		i++
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
