package main

import (
	"fmt"

	"github.com/stretchr/testify/assert"
	"testing"
)

func ExampleMain() {
	main()
	//Output:
	// Part 1: 3100786347
	// Part 2: 87023
}

type TestCase struct {
	prog []int
	in   int
	out  int
}

func TestPlay(t *testing.T) {
	assert.Equal(t,
		"109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99",
		part1([]int64{109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16,
			101, 1006, 101, 0, 99}))
	assert.Equal(t, fmt.Sprintf("%d", 34915192*34915192),
		part1([]int64{1102, 34915192, 34915192, 7, 4, 7, 99, 0}))
	assert.Equal(t, "1125899906842624",
		part1([]int64{104, 1125899906842624, 99}))
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
