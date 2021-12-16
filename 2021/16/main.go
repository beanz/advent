package main

import (
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Packet struct {
	b []byte
	i int
}

func NewPacket(bin []byte) *Packet {
	return &Packet{bin, 0}
}

func NewPacketHex(in []byte) *Packet {
	bin := make([]byte, 0, 4*len(in))
	for _, hex := range in {
		var bits []byte
		switch hex {
		case '0':
			bits = []byte("0000")
		case '1':
			bits = []byte("0001")
		case '2':
			bits = []byte("0010")
		case '3':
			bits = []byte("0011")
		case '4':
			bits = []byte("0100")
		case '5':
			bits = []byte("0101")
		case '6':
			bits = []byte("0110")
		case '7':
			bits = []byte("0111")
		case '8':
			bits = []byte("1000")
		case '9':
			bits = []byte("1001")
		case 'A':
			bits = []byte("1010")
		case 'B':
			bits = []byte("1011")
		case 'C':
			bits = []byte("1100")
		case 'D':
			bits = []byte("1101")
		case 'E':
			bits = []byte("1110")
		case 'F':
			bits = []byte("1111")
		}
		bin = append(bin, bits...)
	}
	return &Packet{bin, 0}
}

func (p *Packet) String() string {
	return string(p.b)
}

func (p *Packet) Num(n int) int {
	v := 0
	for j := p.i; j <p.i+n; j++ {
		v <<= 1
		if p.b[j] == '1' {
			v++
		}
	}
	p.i += n
	return v
}

func (p *Packet) Value(kind int, args []int) int {
	switch kind {
	case 0:
		return Sum(args...)
	case 1:
		return Product(args...)
	case 2:
		return MinInt(args...)
	case 3:
		return MaxInt(args...)
	case 4:
		panic("you wont catch me out like that again")
	case 5:
		if args[0] > args[1] {
			return 1
		}
		return 0
	case 6:
		if args[0] < args[1] {
			return 1
		}
		return 0
	case 7:
		if args[0] == args[1] {
			return 1
		}
		return 0
	default:
		panic(fmt.Sprintf("invalid op %d with arguments: %v\n", kind, args))
	}
}

func (p *Packet) Parts() (int,int) {
	version := p.Num(3)
	kind := p.Num(3)
	if kind == 4 {
		n := 0
		for {
			a := p.Num(5)
			n = (n << 4) + (a & 0xf);
			if a <= 0xf {
				break
			}
		}
		//fmt.Printf("V=%d T=%d N=%d\n", version, kind, n)
		return version, n
	}
	i := p.Num(1)
	if i == 0 { // 15-bit
		l := p.Num(15)
		//fmt.Printf("V=%d T=%d I=%d L=%d\n", version, kind, i, l)
		end := p.i+l
		vs := version
		args := make([]int,0, 4)
		for p.i < end {
			v, n := p.Parts()
			vs += v
			args = append(args, n)
		}
		return vs, p.Value(kind, args)
	}
	l := p.Num(11)
	//fmt.Printf("V=%d T=%d I=%d L=%d\n", version, kind, i, l)
	vs := version
	args := make([]int,0, 4)
	for j := 0; j < l; j++ {
		v, n := p.Parts()
		vs += v
		args = append(args, n)
	}
	return vs, p.Value(kind, args)
}

func main() {
	p := NewPacketHex(InputBytes(input))
	p1, p2 := p.Parts()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
