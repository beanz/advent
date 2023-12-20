package main

import (
	"bytes"
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	p1, p2 := 0, 0
	nums := make([]int, 0, 32)
	for i := 0; i < len(in); {
		start := i
		end := bytes.Index(in[i:], []byte{' '})
		i += end + 1
		VisitUints[int](in, '\n', &i, func(n int) {
			nums = append(nums, n)
		})
		r1 := Solve(in[start:start+end], nums, 1)
		p1 += r1
		r2 := Solve(in[start:start+end], nums, 5)
		p2 += r2
		nums = nums[:0]
		i++
	}
	return p1, p2
}

func Solve(in []byte, nums []int, mul int) int {
	match := make([]byte, 0, 256)
	match = append(match, '.')
	for i := 0; i < len(nums)*mul; i++ {
		for j := 0; j < nums[i%len(nums)]; j++ {
			match = append(match, '#')
		}
		match = append(match, '.')
	}
	state_count := make([]int, 256)
	next_state_count := make([]int, 256)
	state_count[0] = 1
	inLen := len(in)*mul + (mul - 1)
	inChar := func(i int) byte {
		if (i % (len(in) + 1)) == len(in) {
			return '?'
		}
		return in[i%(len(in)+1)]
	}
	for i := 0; i < inLen; i++ {
		ch := inChar(i)
		for state, count := range state_count {
			if count == 0 {
				continue
			}
			nsi := int(state + 1)
			if nsi < len(match) {
				if ch == '?' || ch == match[nsi] {
					next_state_count[state+1] += count
				}
			}
			if ch != '#' && match[int(state)] == '.' {
				next_state_count[state] += count
			}
			state_count[state] = 0
		}
		next_state_count, state_count = state_count, next_state_count
	}
	return state_count[byte(len(match)-1)] + state_count[byte(len(match)-2)]
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
