package aoc

import (
	"fmt"
	"sort"
	"strings"
)

type ByteCounter interface {
	Inc(byte)
	Add(byte, int)
	Top(int) []byte
	Bottom(int) []byte
	Count(byte) int
}

type MapByteCounter struct {
	m map[byte]int
}

func NewMapByteCounter(n int) ByteCounter {
	return &MapByteCounter{make(map[byte]int, n)}
}

func (bc *MapByteCounter) Inc(ch byte) {
	bc.m[ch]++
}

func (bc *MapByteCounter) Add(ch byte, c int) {
	bc.m[ch] += c
}

func (bc *MapByteCounter) Top(n int) []byte {
	chs := make([]byte, 0, len(bc.m))
	for ch := range bc.m {
		chs = append(chs, ch)
	}
	sort.Slice(chs, func(i, j int) bool {
		if bc.m[chs[i]] == bc.m[chs[j]] {
			return chs[i] < chs[j]
		}
		return bc.m[chs[i]] > bc.m[chs[j]]
	})
	return chs[:n]
}

func (bc *MapByteCounter) Bottom(n int) []byte {
	chs := make([]byte, 0, len(bc.m))
	for ch := range bc.m {
		chs = append(chs, ch)
	}
	sort.Slice(chs, func(i, j int) bool {
		if bc.m[chs[i]] == bc.m[chs[j]] {
			return chs[i] > chs[j]
		}
		return bc.m[chs[i]] < bc.m[chs[j]]
	})
	return chs[:n]
}

func (bc *MapByteCounter) Count(ch byte) int {
	return bc.m[ch]
}

type CharCount struct {
	count int
	ch    byte
}

type SliceByteCounter struct {
	s      []CharCount
	sorted bool
}

func NewSliceByteCounter(n int) ByteCounter {
	return &SliceByteCounter{make([]CharCount, 0, n), false}
}

func (bc *SliceByteCounter) String() string {
	var sb strings.Builder
	for i := 0; i < len(bc.s); i++ {
		sb.WriteString(fmt.Sprintf("%s=%d ",
			string(bc.s[i].ch), bc.s[i].count))
	}
	s := sb.String()
	return s[:len(s)-1]
}

func (bc *SliceByteCounter) Sort() {
	sort.Slice(bc.s, func(i, j int) bool {
		if bc.s[i].count == bc.s[j].count {
			return bc.s[i].ch < bc.s[j].ch
		}
		return bc.s[i].count > bc.s[j].count
	})
	bc.sorted = true
}

func (bc *SliceByteCounter) Inc(ch byte) {
	for i := 0; i < len(bc.s); i++ {
		if bc.s[i].ch == ch {
			bc.s[i].count++
			return
		}
	}
	bc.s = append(bc.s, CharCount{ch: ch, count: 1})
}

func (bc *SliceByteCounter) Add(ch byte, c int) {
	for i := 0; i < len(bc.s); i++ {
		if bc.s[i].ch == ch {
			bc.s[i].count += c
			return
		}
	}
	bc.s = append(bc.s, CharCount{ch: ch, count: c})
}

func (bc *SliceByteCounter) Top(n int) []byte {
	if !bc.sorted {
		bc.Sort()
	}
	res := make([]byte, n)
	for i := 0; i < n; i++ {
		res[i] = bc.s[i].ch
	}
	return res
}

func (bc *SliceByteCounter) Bottom(n int) []byte {
	if !bc.sorted {
		bc.Sort()
	}
	res := make([]byte, n)
	for i := 0; i < n; i++ {
		res[i] = bc.s[len(bc.s)-i-1].ch
	}
	return res
}

func (bc *SliceByteCounter) Count(ch byte) int {
	for i := 0; i < len(bc.s); i++ {
		if bc.s[i].ch == ch {
			return bc.s[i].count
		}
	}
	return 0
}
