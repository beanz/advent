package aoc

import (
	"strings"
	"unicode"
)

func Ints(l string) []int {
	return ReadInts(NumberStrings(l))
}

func ReadInts(in []string) []int {
	r := make([]int, len(in))
	for i, s := range in {
		r[i] = MustParseInt(s)
	}
	return r
}

func NumberStrings(s string) []string {
	n := NumberString(s)
	f := func(c rune) bool {
		return !(unicode.IsNumber(c) || c == '-')
	}
	return strings.FieldsFunc(n, f)
}

func NumberString(s string) string {
	n := ""
	for i := 0; i < len(s); i++ {
		if s[i] == '-' &&
			(i == len(s)-1 || !unicode.IsNumber(rune(s[i+1]))) {
			n += " "
		} else {
			n += string(s[i])
		}
	}
	return n
}
