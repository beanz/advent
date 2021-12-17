package main

import (
	"testing"
)

func ExampleMain() {
	main()
	//Output:
	// Part 1: 26464
	// Part 2: 19544
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
