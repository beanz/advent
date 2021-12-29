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

func FastInts(l []byte, expected int) []int {
	res := make([]int, 0, expected)
	n := 0
	num := false
	for _, ch := range l {
		if ch >= '0' && ch <= '9' {
			num = true
			n = n*10 + int(ch-'0')
		} else if num {
			res = append(res, n)
			n = 0
			num = false
		}
	}
	if num {
		res = append(res, n)
	}
	return res
}

func FastSignedInts(l []byte, expected int) []int {
	res := make([]int, 0, expected)
	n := 0
	m := 1
	num := false
	for _, ch := range l {
		if ch == '-' {
			m = -1
		} else if ch >= '0' && ch <= '9' {
			num = true
			n = n*10 + int(ch-'0')
		} else if num {
			res = append(res, n*m)
			n = 0
			m = 1
			num = false
		}
	}
	if num {
		res = append(res, n*m)
	}
	return res
}

func FastBytes(l []byte) []byte {
	res := l[:0]
	var n byte
	num := false
	for _, ch := range l {
		if ch >= '0' && ch <= '9' {
			num = true
			n = n*10 + ch - '0'
		} else if num {
			res = append(res, n)
			n = 0
			num = false
		}
	}
	if num {
		res = append(res, n)
	}
	return res
}

func FastInt64s(l []byte, expected int) []int64 {
	res := make([]int64, 0, expected)
	var n int64
	var m int64 = 1
	num := false
	for _, ch := range l {
		if ch == '-' {
			m = -1
		} else if ch >= '0' && ch <= '9' {
			num = true
			n = n*10 + int64(ch-'0')
		} else if num {
			res = append(res, n*m)
			n = 0
			m = 1
			num = false
		}
	}
	if num {
		res = append(res, n*m)
	}
	return res
}

func ScanUint(in []byte, i int) (int, int) {
	n := 0
	j := i
	for ; j < len(in); j++ {
		if in[j] >= '0' && in[j] <= '9' {
			n = n*10 + int(in[j]-'0')
		} else {
			break
		}
	}
	return n, j
}

func ScanInt(in []byte, i int) (int, int) {
	n := 0
	j := i
	m := 1
	if in[j] == '-' {
		m = -1
		j++
	}
	for ; j < len(in); j++ {
		if in[j] >= '0' && in[j] <= '9' {
			n = n*10 + int(in[j]-'0')
		} else {
			break
		}
	}
	return n * m, j
}
