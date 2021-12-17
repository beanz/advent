package main

import (
	"testing"
)

func ExampleMain() {
	main()
	//Output:
	// Part 1: 3448
	// Part 2: 762405
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
