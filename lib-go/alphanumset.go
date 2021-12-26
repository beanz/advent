package aoc

import (
	"math/bits"
	"strings"
)

type AlphaNumSet uint64

func NewAlphaNumSet() AlphaNumSet {
	return AlphaNumSet(0)
}

func (s AlphaNumSet) Add(ch byte) AlphaNumSet {
	s |= AlphaNumBit(ch)
	return s
}

func (s AlphaNumSet) Size() int {
	return bits.OnesCount64(uint64(s))
}

func (s AlphaNumSet) Contains(ch byte) bool {
	return (s & AlphaNumBit(ch)) != 0
}

func (s AlphaNumSet) String() string {
	var sb strings.Builder
	var bit AlphaNumSet = 1
	for ch := byte('0'); ch <= '9'; ch, bit = ch+1, bit<<1 {
		if (s & bit) != 0 {
			sb.WriteByte(ch)
		}
	}
	for ch := byte('A'); ch <= 'Z'; ch, bit = ch+1, bit<<1 {
		if (s & bit) != 0 {
			sb.WriteByte(ch)
		}
	}
	for ch := byte('a'); ch <= 'z'; ch, bit = ch+1, bit<<1 {
		if (s & bit) != 0 {
			sb.WriteByte(ch)
		}
	}
	return sb.String()
}

func AlphaNumBit(ch byte) AlphaNumSet {
	switch {
	case ch >= 97:
		ch -= (6 + 7 + 48)
	case ch >= 65:
		ch -= (7 + 48)
	case ch >= 48:
		ch -= 48
	}
	return AlphaNumSet(1 << ch)
}
