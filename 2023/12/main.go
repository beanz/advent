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

func Solve(inO []byte, nums []int, mul int) int {
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
	in := make([]byte, 0, mul*len(inO)+mul-1)
	in = append(in, inO...)
	for k := 1; k < mul; k++ {
		in = append(in, '?')
		in = append(in, inO...)
	}
	for _, ch := range in {
		for state, count := range state_count {
			if count == 0 {
				continue
			}
			nsi := int(state + 1)
			if ch == '#' {
				if nsi < len(match) && match[nsi] == '#' {
					next_state_count[state+1] += count
				}
			} else if ch == '.' {
				if nsi < len(match) && match[nsi] == '.' {
					next_state_count[state+1] += count
				}
				if match[int(state)] == '.' {
					next_state_count[state] += count
				}
			} else {
				if nsi < len(match) {
					next_state_count[state+1] += count
				}
				if match[int(state)] == '.' {
					next_state_count[state] += count
				}
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
