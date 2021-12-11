package aoc

import (
	"sort"
)

func SimpleMedianN(inp []int, n int) int {
	sort.Ints(inp)
	return inp[n]
}

func MedianOfMedians(inp []int, n int) int {
	if len(inp) <= 10 {
		return SimpleMedianN(inp, n)
	}

	numSlices := (len(inp) + 4) / 5
	meds := make([]int, numSlices)
	for i := 0; i < numSlices; i++ {
		start := i * 5
		end := start + 5
		if end > len(inp) {
			end = len(inp)
		}
		sort.Ints(inp[start:end])
		meds[i] = inp[(start+end)/2]
	}
	pivot := MedianOfMedians(meds, len(meds)/2)
	var lhs, equal, rhs []int
	for i := range inp {
		if inp[i] < pivot {
			lhs = append(lhs, inp[i])
		} else if inp[i] > pivot {
			rhs = append(rhs, inp[i])
		} else {
			equal = append(equal, inp[i])
		}
	}
	if n < len(lhs) {
		return MedianOfMedians(lhs, n)
	} else if n < len(lhs)+len(equal) {
		return pivot
	}
	return MedianOfMedians(rhs, n-len(lhs)-len(equal))
}
