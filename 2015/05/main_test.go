package main

import (
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/beanz/advent/lib-go/tester"
)

type TestCaseNice struct {
	in   string
	nice bool
}

func TestNice1(t *testing.T) {
	tests := []TestCaseNice{
		{"ugknbfddgicrmopn", true},
		{"aaa", true},
		{"jchzalrnumimnmhp", false},
		{"haegwjzuvuyypxyu", false},
		{"dvszwmarrgswjxmb", false},
	}
	for _, tc := range tests {
		n, _ := nice(tc.in)
		assert.Equal(t, tc.nice, n, "nice 1: "+tc.in)
	}
}

func TestNice2(t *testing.T) {
	tests := []TestCaseNice{
		{"qjhvhtzxzqqjkmpb", true},
		{"xxyxx", true},
		{"uurcxstgmygtbstg", false},
		{"ieodomkazucvgmuy", false},
	}
	for _, tc := range tests {
		_, n := nice(tc.in)
		assert.Equal(t, tc.nice, n, "nice 2: "+tc.in)
	}
}

func TestParts(t *testing.T) {
	tester.RunWithArgs(t, Parts)
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
