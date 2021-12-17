package main

import (
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
	"math/bits"
	"strings"
)

//go:embed input.txt
var input []byte

type Disp struct {
	rows []uint64
	w, h int
}

func NewDisp(w, h int) *Disp {
	return &Disp{make([]uint64, h), w, h}
}

func (d *Disp) Count() int {
	c := 0
	for y := 0; y < d.h; y++ {
		c += bits.OnesCount64(d.rows[y])
	}
	return c
}

func (d *Disp) Rect(w, h int) {
	for y := 0; y < h; y++ {
		d.rows[y] |= (1 << w) - 1
	}
}

func (d *Disp) RotateColumn(x, n int) {
	x++
	var set uint64 = (1 << (x - 1))
	var reset uint64 = ((1 << d.w) - 1) ^ set
	for i := 0; i < n; i++ {
		last := d.rows[0]&set != 0
		for y := 1; y < d.h; y++ {
			cur := d.rows[y]&set != 0
			if last && !cur {
				d.rows[y] |= set
			} else if !last && cur {
				d.rows[y] &= reset
			}
			last = cur
		}
		cur := d.rows[0]&set != 0
		if last && !cur {
			d.rows[0] |= set
		} else if !last && cur {
			d.rows[0] &= reset
		}
	}
}

func (d *Disp) RotateRow(y, n int) {
	for i := 0; i < n; i++ {
		last := d.rows[y]&(1<<(d.w-1)) != 0
		d.rows[y] <<= 1
		if last {
			d.rows[y]++
		}
	}
}

func (d *Disp) String() string {
	var sb strings.Builder
	for y := 0; y < d.h; y++ {
		for x := 0; x < d.w; x++ {
			if d.rows[y]&(1<<x) != 0 {
				sb.WriteByte('#')
			} else {
				sb.WriteByte('.')
			}
		}
		sb.WriteByte('\n')
	}
	return sb.String()
}

func (d *Disp) Run(in []byte) {
	for i := 0; i < len(in)-1; i++ {
		switch in[i+1] {
		case 'e':
			i += 5 // 'rect '
			w, i := ScanUint(in, i)
			i++ // 'x'
			h, i := ScanUint(in, i)
			i++ // '\n'
			//fmt.Printf("rect %d,%d\n", w, h)
			d.Rect(w, h)
		case 'o':
			if in[i+7] == 'r' {
				i += 13 // 'rotate row y='
				y, i := ScanUint(in, i)
				i += 4 // ' by '
				n, i := ScanUint(in, i)
				i++ // '\n'
				//fmt.Printf("rr %d,%d\n", y, n)
				d.RotateRow(y, n)
			} else {
				i += 16 // 'rotate column y='
				x, i := ScanUint(in, i)
				i += 4 // ' by '
				n, i := ScanUint(in, i)
				i++ // '\n'
				//fmt.Printf("rc %d,%d\n", x, n)
				d.RotateColumn(x, n)
			}
		}
	}
}

func main() {
	w, h := 50, 6
	if InputFile() == "test.txt" {
		w, h = 7, 3
	}
	disp := NewDisp(w, h)
	disp.Run(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", disp.Count())
		fmt.Printf("Part 2:\n\n%s", disp)
	}
}

var benchmark = false
