package aoc

import (
	"log"
	"strconv"
)

func MustParseUint64(s string) uint64 {
	n, err := strconv.ParseUint(s, 10, 64)
	if err != nil {
		log.Fatalf("%s not valid uint64\n", s)
	}
	return n
}

func MustParseInt64(s string) int64 {
	n, err := strconv.ParseInt(s, 10, 64)
	if err != nil {
		log.Fatalf("%s not valid int64\n", s)
	}
	return n
}

func MustParseUint(s string) uint {
	n, err := strconv.ParseUint(s, 10, 32)
	if err != nil {
		log.Fatalf("%s not valid uint32\n", s)
	}
	return uint(n)
}

func MustParseInt(s string) int {
	n, err := strconv.ParseInt(s, 10, 32)
	if err != nil {
		log.Fatalf("%s not valid int32\n", s)
	}
	return int(n)
}

func ReverseString(s string) (r string) {
	for _, v := range s {
		r = string(v) + r
	}
	return
}

func RotateStrings(lines []string) []string {
	res := []string{}
	for i := 0; i < len(lines[0]); i++ {
		s := ""
		for j := len(lines) - 1; j >= 0; j-- {
			s += string(lines[j][i])
		}
		res = append(res, s)
	}
	return res
}

func ReverseStringList(lines []string) []string {
	res := make([]string, len(lines))
	for i := 0; i < len(lines); i++ {
		res[len(lines)-1-i] = lines[i]
	}
	return res
}

func ReverseIntList(lines []int) []int {
	res := make([]int, len(lines))
	for i := 0; i < len(lines); i++ {
		res[len(lines)-1-i] = lines[i]
	}
	return res
}

func StringListContains(l []string, e string) bool {
	for _, ee := range l {
		if e == ee {
			return true
		}
	}
	return false
}

func IntListContains(l []int, e int) bool {
	for _, ee := range l {
		if e == ee {
			return true
		}
	}
	return false
}
