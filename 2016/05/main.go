package main

import (
	"crypto/md5"
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Door struct {
	doorID string
	ns     *NumStr
	debug  bool
}

func (d *Door) String() string {
	return fmt.Sprintf("Door ID: %s\n", d.doorID)
}

func NewDoor(line string) *Door {
	return &Door{line, NewNumStr(line), false}
}

func (d *Door) reset() {
	d.ns = NewNumStr(d.doorID)
}

func (d *Door) nextPassword() string {
	p := ""
	for i := 0; i < 8; i++ {
		p += string(d.nextCharacter())
	}
	return p
}

func (d *Door) nextSum() string {
	var sum [16]byte
	for {
		sum = md5.Sum(d.ns.Bytes())
		d.ns.Inc()
		if sum[0] == 0 && sum[1] == 0 && (sum[2]&0xf0) == 0 {
			break
		}
	}
	return fmt.Sprintf("%x", sum)
}

func (d *Door) nextCharacter() rune {
	return rune(d.nextSum()[5])
}

func (d *Door) Part1() string {
	return d.nextPassword()
}

func (d *Door) nextStrongPassword() string {
	pass := []rune{'_', '_', '_', '_', '_', '_', '_', '_'}
	var s string
	for {
		sum := d.nextSum()
		pos := byte(sum[5]) - 48
		if pos > 7 {
			continue
		}
		if pass[pos] != '_' {
			continue
		}
		pass[pos] = rune(sum[6])
		s = ""
		finished := true
		for _, r := range pass {
			s += string(r)
			if r == '_' {
				finished = false
			}
		}
		if finished {
			break
		}
		//fmt.Printf("%s %d %s %s\n", sum, pos, string(rune(sum[6])), s)
	}
	return s
}

func (d *Door) Part2() string {
	d.reset()
	return d.nextStrongPassword()
}

func main() {
	door := NewDoor(InputLines(input)[0])

	res := door.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %s\n", res)
	}

	res = door.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %s\n", res)
	}
}

var benchmark = false
