package aoc

import (
	"fmt"
	"strings"
)

type ByteMap struct {
	d    []byte
	w, h int
}

func NewByteMap(in []byte) (i *ByteMap) {
	var w int
	for i, ch := range in {
		if ch == '\n' {
			w = i + 1 // +1 since we are keeping the newlines
			break
		}
	}
	h := len(in) / w
	return &ByteMap{in, w, h}
}

func (m *ByteMap) String() string {
	var sb strings.Builder
	for y := 0; y < m.h; y++ {
		sb.WriteString(string(m.d[y*m.w : (1+y)*m.w]))
	}
	sb.WriteString(fmt.Sprintf("%d x %d\n", m.w, m.h))
	return sb.String()
}

func (m *ByteMap) Width() int {
	return m.w - 1
}

func (m *ByteMap) Height() int {
	return m.h
}

func (m *ByteMap) Size() int {
	return (m.w - 1) * m.h
}

func (m *ByteMap) IndexToString(i int) string {
	return fmt.Sprintf("%d,%d", i%m.w, i/m.w)
}

func (m *ByteMap) IndexToXY(i int) (int, int) {
	return i % m.w, i / m.w
}

func (m *ByteMap) XYToIndex(x, y int) int {
	return x + y*m.w
}

func (m *ByteMap) Contains(i int) bool {
	return i >= 0 && (i%m.w) < m.w-1 && i < m.h*m.w
}

func (m *ByteMap) Get(i int) byte {
	return m.d[i]
}

func (m *ByteMap) GetXY(x, y int) byte {
	return m.d[x+y*m.w]
}

func (m *ByteMap) Set(i int, v byte) {
	m.d[i] = v
}

func (m *ByteMap) SetXY(x, y int, v byte) {
	m.d[x+y*m.w] = v
}

func (m *ByteMap) Add(i int, v byte) {
	m.d[i] += v
}

func (m *ByteMap) Neighbours(i int) []int {
	x, y := m.IndexToXY(i)
	res := make([]int, 0, 4)
	if x > 0 {
		res = append(res, i-1)
	}
	if x < m.w-2 { // because we've still got newlines!
		res = append(res, i+1)
	}
	if y > 0 {
		res = append(res, i-m.w)
	}
	if y < m.h-1 {
		res = append(res, i+m.w)
	}
	return res
}

func (m *ByteMap) NeighbourValues(i int) []byte {
	x, y := m.IndexToXY(i)
	res := make([]byte, 0, 4)
	if x > 0 {
		res = append(res, m.d[i-1])
	}
	if x < m.w-2 { // because we've still got newlines!
		res = append(res, m.d[i+1])
	}
	if y > 0 {
		res = append(res, m.d[i-m.w])
	}
	if y < m.h-1 {
		res = append(res, m.d[i+m.w])
	}
	return res
}

func (m *ByteMap) Neighbours8(i int) []int {
	res := make([]int, 0, 8)
	x, y := m.IndexToXY(i)
	for ny := y - 1; ny <= y+1; ny++ {
		for nx := x - 1; nx <= x+1; nx++ {
			if nx == x && ny == y {
				continue
			}
			if nx >= 0 && nx < m.w-1 && ny >= 0 && ny < m.h {
				res = append(res, nx+ny*m.w)
			}
		}
	}
	return res
}

func (m *ByteMap) Visit(fn func(i int, v byte) (byte, bool)) {
	for y := 0; y < m.h; y++ {
		for x := 0; x < m.w-1; x++ { // -1 due to newlines
			i := x + y*m.w
			if v, update := fn(i, m.d[i]); update {
				m.d[i] = v
			}
		}
	}
}
