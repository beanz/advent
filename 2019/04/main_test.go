package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

type TestCase struct {
	i   int
	res int
}

func TestPlay(t *testing.T) {
	tests := []TestCase{
		{111111, 1},
		{223450, 0},
		{123789, 0},
		{123444, 1},
		{111122, 1},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.res, Part1([]int{tc.i, tc.i}))
	}
	assert.Equal(t, 931, Part1([]int{272091, 815432}))

	tests = []TestCase{
		{112233, 1},
		{123444, 0},
		{111122, 1},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.res, Part2([]int{tc.i, tc.i}))
	}
	assert.Equal(t, 609, Part2([]int{272091, 815432}))

}
