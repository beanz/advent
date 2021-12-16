package main

import (
	_ "embed"
	"encoding/hex"
	"fmt"
	"strings"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Packet struct {
	bs *BitStream
}

func NewPacket(in []byte) *Packet {
	bs, err := NewBitStreamFromHexBytes(in[:len(in)-1])
	if err != nil {
		panic(err)
	}
	return &Packet{bs}
}

func (p *Packet) String() string {
	return p.bs.String()
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
	version := p.bs.MustNum(3)
	kind := p.bs.MustNum(3)
	if kind == 4 {
		n := 0
		for {
			a := p.bs.MustNum(5)
			n = (n << 4) + (a & 0xf);
			if a <= 0xf {
				break
			}
		}
		//fmt.Printf("V=%d T=%d N=%d\n", version, kind, n)
		return version, n
	}
	i := p.bs.MustNum(1)
	if i == 0 { // 15-bit
		l := p.bs.MustNum(15)
		//fmt.Printf("V=%d T=%d I=%d L=%d\n", version, kind, i, l)
		end := p.bs.Pos()+l
		vs := version
		args := make([]int,0, 4)
		for p.bs.Pos() < end {
			v, n := p.Parts()
			vs += v
			args = append(args, n)
		}
		return vs, p.Value(kind, args)
	}
	l := p.bs.MustNum(11)
	//fmt.Printf("V=%d T=%d I=%d L=%d\n", version, kind, i, l)
	vs := version
	args := make([]int, 0, 4)
	for j := 0; j < l; j++ {
		v, n := p.Parts()
		vs += v
		args = append(args, n)
	}
	return vs, p.Value(kind, args)
}

func main() {
	p := NewPacket(InputBytes(input))
	p1, p2 := p.Parts()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false

type BitStream struct {
	b []byte
	ibit int
	len int
}

func NewBitStream(b []byte) *BitStream {
	return &BitStream{b, 0, len(b)*8}
}

func NewBitStreamFromHexBytes(hb []byte) (*BitStream, error) {
	b := make([]byte, 0, len(hb)/2)
	for i := 0; i < len(hb); i+=2 {
		var v byte
		switch {
		case '0' <= hb[i] && hb[i] <= '9':
			v = hb[i]-'0'
		case 'A' <= hb[i] && hb[i] <= 'F':
			v = 10+hb[i]-'A'
		case 'a' <= hb[i] && hb[i] <= 'f':
			v = 10+hb[i]-'a'
		default:
			return nil, fmt.Errorf("invalid hex digit %s", string(hb[i]))
		}
		v <<= 4
		switch {
		case '0' <= hb[i+1] && hb[i+1] <= '9':
			v += hb[i+1]-'0'
		case 'A' <= hb[i+1] && hb[i+1] <= 'F':
			v += 10+hb[i+1]-'A'
		case 'a' <= hb[i+1] && hb[i+1] <= 'f':
			v += 10+hb[i+1]-'a'
		default:
			return nil, fmt.Errorf("invalid hex digit %s", string(hb[i]))
		}
		b = append(b, v)
	}
	return &BitStream{b, 0, len(b)*8}, nil
}

func NewBitStreamFromHexString(s string) (*BitStream, error) {
	b, err := hex.DecodeString(s)
	if err != nil {
		return nil, err
	}
	return NewBitStream(b), nil
}

func (bs *BitStream) String() string {
	var sb strings.Builder
	for _, b := range bs.b {
		fmt.Fprintf(&sb, "%08b", b)
	}
	return sb.String()
}

func (bs *BitStream) Pos() int {
	return bs.ibit
}

func (bs *BitStream) MustNum(bits int) int {
	n, err := bs.Num(bits)
	if err != nil {
		panic(err)
	}
	return n
}

func (bs *BitStream) Num(bits int) (int, error) {
	if bs.ibit + bits > bs.len {
		return 0, fmt.Errorf("out of bits: have %d wanted %d",
			bs.len-bs.ibit, bits)
	}
	v := 0
	for bits > 0 {
		rb := 8 - (bs.ibit % 8);
		i := bs.ibit / 8;
		if bits <= rb {
			v <<= bits;
			v += (int(bs.b[i]) >> (rb - bits)) & ((1 << bits) - 1);
			bs.ibit += bits;
			bits = 0;
		} else {
			v <<= rb;
			v += int(bs.b[i]) & ((1 << rb) - 1);
			bits -= rb;
			bs.ibit += rb;
		}
	}
	return v, nil
}
