package aoc

type AoCUnsigned interface { ~uint|~uint8|~uint16|~uint32|~uint64 }
type AoCSigned interface { ~byte|int|~int8|~int16|~int32|~int64 }
type AoCInt interface { AoCUnsigned|AoCSigned }

func ChompUInt[T AoCInt](in []byte, i int) (j int, n T) {
	j = i
	for ; '0' <= in[j] && in[j] <= '9'; j++ {
		n = T(10)*n + T(in[j]-'0')
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
		n = T(10)*n + T(in[j]-'0')
	}
	if negative {
		return j, -n
	}
	return j, n
}
