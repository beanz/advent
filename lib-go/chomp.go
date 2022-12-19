package aoc

type AoCUnsigned interface { ~uint|~uint8|~uint16|~uint32|~uint64 }
type AoCSigned interface { ~byte|int|~int8|~int16|~int32|~int64 }
type AoCInt interface { AoCUnsigned|AoCSigned }

func ChompUInt[T AoCInt](in []byte, i int) (j int, n T) {
	j = i
	for ; '0' <= in[j] && in[j] <= '9'; j++ {
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
	}
	for ; '0' <= in[j] && in[j] <= '9'; j++ {
		n = T(10)*n + T(in[j]&0xf)
	}
	if negative {
		return j, -n
	}
	return j, n
}

func ChompToNextLine(in []byte, i int) int {
	for in[i] != '\n' {
		i++
	}
	i++
	return i
}

var isDigit = [256]bool{48: true, 49: true, 50: true, 51: true, 52: true, 53: true, 54: true, 55: true, 56: true, 57: true}

func ChompOneOrTwoCharUInt[T AoCInt](in []byte, i int) (int, T) {
	if isDigit[in[i+1]] {
		return i + 2, 10*T(in[i]&0xf) + T(in[i+1]&0xf)
	}
	return i + 1, T(in[i]&0xf)
}
