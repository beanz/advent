package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, 588, Part1([]int{65, 8921}))
	assert.Equal(t, 612, Part1([]int{722, 354}))
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 309, Part2([]int{65, 8921}))
	assert.Equal(t, 285, Part2([]int{722, 354}))
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
