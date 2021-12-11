package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

type TestCaseValid struct {
	in    string
	valid bool
}

func TestValid(t *testing.T) {
	tests := []TestCaseValid{
		{"hijklmmn", false},
		{"abbceffg", false},
		{"abbcegjk", false},
		{"abcdffaa", true},
		{"ghjaabcc", true},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.valid, Valid(tc.in), "valid: "+tc.in)
	}
}

type TestCaseNext struct {
	cur, next string
}

func TestNext(t *testing.T) {
	tests := []TestCaseNext{
		{"abcdefgh", "abcdffaa"},
		{"ghijklmn", "ghjaabcc"},
		{ReadFileLines("input.txt")[0], "vzbxxyzz"},
		{"vzbxxyzz", "vzcaabcc"},
	}
	for _, tc := range tests {
		assert.Equal(t, tc.next, Next(tc.cur), "next: "+tc.cur)
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
