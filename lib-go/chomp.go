package aoc

import "bytes"

type AoCUnsigned interface {
	~uint | ~uint8 | ~uint16 | ~uint32 | ~uint64
}
type AoCSigned interface {
	~byte | int | ~int8 | ~int16 | ~int32 | ~int64
}
type AoCInt interface{ AoCUnsigned | AoCSigned }

func ChompUInt[T AoCInt](in []byte, i int) (j int, n T) {
	j = i
	if !('0' <= in[j] && in[j] <= '9') {
		panic("not a number")
	}
	for ; j < len(in) && '0' <= in[j] && in[j] <= '9'; j++ {
		n = T(10)*n + T(in[j]&0xf)
	}
	return
}

func ChompInt[T AoCSigned](in []byte, i int) (int, T) {
	j, n := i, T(0)
	var negative bool
	if in[j] == '-' {
		negative = true
		j++
	} else if in[j] == '+' {
		j++
	}
	if !('0' <= in[j] && in[j] <= '9') {
		panic("not a number")
	}
	for ; j < len(in) && '0' <= in[j] && in[j] <= '9'; j++ {
		n = T(10)*n + T(in[j]&0xf)
	}
	if negative {
		return j, -n
	}
	return j, n
}

func ChompToNextLine(in []byte, i int) int {
	j := bytes.IndexByte(in[i:], '\n')
	if j == -1 {
		return len(in)
	}
	return i + j + 1
}

func ChompOneOrTwoCharUInt[T AoCInt](in []byte, i int) (int, T) {
	if !('0' <= in[i] && in[i] <= '9') {
		panic("not a number")
	}
	if '0' <= in[i+1] && in[i+1] <= '9' {
		return i + 2, 10*T(in[i]&0xf) + T(in[i+1]&0xf)
	}
	return i + 1, T(in[i] & 0xf)
}

func VisitInts[T AoCSigned](in []byte, until byte, i *int, fn func(n T)) {
	var n T
	var num bool
	var negative bool
	for {
		switch {
		case in[*i] == until:
			if num {
				if negative {
					fn(-n)
				} else {
					fn(n)
				}
			}
			return
		case '0' <= in[*i] && in[*i] <= '9':
			num = true
			n = n*10 + T(in[*i]&0xf)
		case in[*i] == '-':
			negative = true
		default:
			if num {
				if negative {
					fn(-n)
				} else {
					fn(n)
				}
			}
			num = false
			negative = false
			n = 0
		}
		*i++
	}
}

func VisitUints[T AoCInt](in []byte, until byte, i *int, fn func(n T)) {
	var n T
	var num bool
	for {
		switch {
		case in[*i] == until:
			if num {
				fn(n)
			}
			return
		case '0' <= in[*i] && in[*i] <= '9':
			num = true
			n = n*10 + T(in[*i]&0xf)
		default:
			if num {
				fn(n)
			}
			num = false
			n = 0
		}
		*i++
	}
}

func VisitWords(in []byte, until byte, i *int, fn func(w []byte, term byte)) {
	var word bool
	j := 0
	k := 0
LOOP:
	for {
		switch {
		case in[*i] == until:
			if word {
				fn(in[j:k+1], in[*i])
			}
			break LOOP
		case 'a' <= in[*i] && in[*i] <= 'z':
			if !word {
				j = *i
			}
			word = true
			k = *i
		case 'A' <= in[*i] && in[*i] <= 'Z':
			if !word {
				j = *i
			}
			word = true
			k = *i
		case '0' <= in[*i] && in[*i] <= '9':
			if !word {
				j = *i
			}
			word = true
			k = *i
		default:
			if word {
				fn(in[j:k+1], in[*i])
			}
			word = false
		}
		*i++
	}
}

func VisitSplit(in []byte, sep, until byte, i *int, fn func(s []byte)) {
	var word bool
	j := 0
	k := 0
LOOP:
	for {
		switch in[*i] {
		case until:
			if word {
				fn(in[j : k+1])
			}
			break LOOP
		case sep:
			if word {
				fn(in[j : k+1])
			}
			word = false
		default:
			if !word {
				j = *i
			}
			word = true
			k = *i
		}
		*i++
	}
}

func VisitNInts[T AoCSigned](in []byte, offsets []int, fn func(args ...T)) {
	a := make([]T, len(offsets)-1)
	for i := 0; i < len(in); {
		for j := 0; j < len(offsets)-1; j++ {
			o := offsets[j]
			i, a[j] = ChompInt[T](in, i+o)
		}
		fn(a...)
		i += offsets[len(offsets)-1]
	}
}

func VisitNUints[T AoCInt](in []byte, offsets []int, fn func(args ...T)) {
	a := make([]T, len(offsets)-1)
	for i := 0; i < len(in); {
		for j := 0; j < len(offsets)-1; j++ {
			o := offsets[j]
			i, a[j] = ChompUInt[T](in, i+o)
		}
		fn(a...)
		i += offsets[len(offsets)-1]
	}
}
