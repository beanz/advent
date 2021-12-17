package main

import (
	"testing"
)

func ExampleMain() {
	main()
	//Output:
	// Part 1: 398
	// Part 2: 19447
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
