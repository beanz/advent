package main

import (
	"testing"
)

func ExampleMain() {
	main()
	//Output:
	// Part 1: 235,14
	// Part 2: 237,227,14
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
