package main

import (
	_ "embed"
	"testing"

	"github.com/beanz/advent/lib-go/tester"
)

//go:embed input.txt
var safeinput []byte

func ExampleMain() {
	main()
	//Output:
	// Part 1: 33520
	// Part 2: 34824
}

func TestParts(t *testing.T) {
	tester.RunWithArgs(t, Parts)
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		b.StopTimer()
		copy(input, safeinput)
		b.StartTimer()
		main()
	}
}