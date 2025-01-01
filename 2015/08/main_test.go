package main

import (
	"testing"

	"github.com/beanz/advent/lib-go/tester"
)

func TestParts(t *testing.T) {
	tester.RunWithArgs(t, Parts)
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
