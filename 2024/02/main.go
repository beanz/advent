package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Safe(nums []int) bool {
	var inc, dec bool
	for i := 1; i < len(nums); i++ {
		d := nums[i-1] - nums[i]
		switch d {
		case -1, -2, -3:
			inc = true
		case 1, 2, 3:
			dec = true
		default:
			return false
		}
		if dec && inc {
			return false
		}
	}
	return true
}

func SafeWithSkip(nums []int, skip int) bool {
	var inc, dec bool
	p := nums[0]
	for i := 1; i < len(nums); i++ {
		if i == skip {
			continue
		}
		d := p - nums[i]
		switch d {
		case -1, -2, -3:
			inc = true
		case 1, 2, 3:
			dec = true
		default:
			return false
		}
		if dec && inc {
			return false
		}
		p = nums[i]
	}
	return true
}

func Safe2(nums []int) bool {
	if Safe(nums[1:]) {
		return true
	}
	if Safe(nums[:len(nums)-1]) {
		return true
	}
	for i := 1; i < len(nums)-1; i++ {
		if SafeWithSkip(nums, i) {
			return true
		}
	}
	return false
}

func Parts(in []byte, args ...int) (int, int) {
	p1, p2 := 0, 0
	l := make([]int, 0, 16)
	for i := 0; i < len(in); {
		for in[i] != '\n' {
			var n int
			i, n = ChompUInt[int](in, i)
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
		l = l[:0]
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
