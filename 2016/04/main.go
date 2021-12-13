package main

import (
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
	"strings"
)

//go:embed input.txt
var input []byte

type Room struct {
	name   []byte
	sector int
	chk    []byte
	cc     ByteCounter
}

func (r *Room) String() string {
	var sb strings.Builder
	sb.WriteString(string(r.name))
	sb.WriteByte(' ')
	fmt.Fprintf(&sb, "%d ", r.sector)
	sb.WriteString(string(r.chk))
	fmt.Fprintf(&sb, " %v", r.cc)
	return sb.String()
}

func (r *Room) RealName() string {
	rn := make([]byte, len(r.name))
	for i := 0; i < len(r.name); i++ {
		if r.name[i] == '-' {
			rn[i] = ' '
			continue
		}
		n := int(r.name[i] - 'a')
		n += r.sector
		n %= 26
		rn[i] = byte(n) + 'a'
	}
	return string(rn)
}

type Kiosk struct {
	rooms []*Room
}

func NewKiosk(in []byte) *Kiosk {
	k := &Kiosk{rooms: make([]*Room, 0, 1024)}
	start := 0
	end := 0
	bc := NewSliceByteCounter(26)
	var name []byte
	sector := 0
	isCheck := false
	for i := 0; i < len(in); i++ {
		ch := in[i]
		switch {
		case ch == '[':
			name = in[start:end]
			start = i + 1
			isCheck = true
		case ch == ']':
			k.rooms = append(k.rooms, &Room{name, sector, in[start:i], bc})
			sector = 0
			start = i + 2
			end = i + 2
			isCheck = false
			bc = NewSliceByteCounter(26)
		case '0' <= ch && ch <= '9':
			sector = sector*10 + int(in[i]-'0')
		case 'a' <= ch && ch <= 'z':
			if !isCheck {
				bc.Inc(ch)
			}
			end = i + 1
		}
	}
	return k
}

func (k *Kiosk) String() string {
	var sb strings.Builder
	for _, r := range k.rooms {
		sb.WriteString(r.String())
		sb.WriteByte('\n')
	}
	return sb.String()
}

func (k *Kiosk) Part1() int {
	c := 0
ROOM:
	for _, r := range k.rooms {
		top5 := r.cc.Top(5)
		for i := 0; i < len(r.chk); i++ {
			if r.chk[i] != top5[i] {
				continue ROOM
			}
		}
		c += r.sector
	}
	return c
}

func (k *Kiosk) Part2() int {
	for _, r := range k.rooms {
		if r.RealName()[0:5] == "north" {
			return r.sector
		}
	}
	return -1
}

func main() {
	k := NewKiosk(InputBytes(input))
	p1 := k.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := k.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
