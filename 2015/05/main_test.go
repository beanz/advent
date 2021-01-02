package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
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
	in := ReadFileLines("input.txt")
	p1, p2 := calc(in)
	assert.Equal(t, 258, p1)
	assert.Equal(t, 53, p2)
}
