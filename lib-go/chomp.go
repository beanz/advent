package aoc

import "bytes"

type AoCUnsigned interface { ~uint|~uint8|~uint16|~uint32|~uint64 }
type AoCSigned interface { ~byte|int|~int8|~int16|~int32|~int64 }
type AoCInt interface { AoCUnsigned|AoCSigned }

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
	return i+j+1
}

func ChompOneOrTwoCharUInt[T AoCInt](in []byte, i int) (int, T) {
	if !('0' <= in[i] && in[i] <= '9') {
		panic("not a number")
	}
	if '0' <= in[i+1] && in[i+1] <= '9' {
		return i + 2, 10*T(in[i]&0xf) + T(in[i+1]&0xf)
	}
	return i + 1, T(in[i]&0xf)
}
