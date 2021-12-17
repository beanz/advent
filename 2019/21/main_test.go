package main

import (
	"testing"
)

func ExampleMain() {
	main()
	//Output:
	// Part 1: 19359969
	// Part 2: 1140082748
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
