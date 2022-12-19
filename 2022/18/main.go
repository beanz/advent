package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Pos int32

func NewPos(x, y, z int) Pos {
	return Pos((x << 10) + (y << 5) + z)
}
func (p Pos) xyz() (int, int, int) {
	return int(p >> 10), int((p >> 5) & 0x1f), int(p & 0x1f)
}

func Parts(in []byte) (int, int) {
	pos := [2560]Pos{}
	j := 0
	mx := 0
	my := 0
	mz := 0
	for i := 0; i < len(in); {
		var x, y, z int
		i, x = ChompOneOrTwoCharUInt[int](in, i)
		x += 2
		i++
		i, y = ChompOneOrTwoCharUInt[int](in, i)
		y += 2
		i++
		i, z = ChompOneOrTwoCharUInt[int](in, i)
		z += 2
		i++
		pos[j] = NewPos(x, y, z)
		j++
		if mx < x {
			mx = x
		}
		if my < y {
			my = y
		}
		if mz < z {
			mz = z
		}
	}
	p1 := 6 * j
	thing := [32768]bool{}
	for i := 0; i < j; i++ {
		thing[pos[i]] = true
		if thing[pos[i]-1024] {
			p1 -= 2
		}
		if thing[pos[i]+1024] {
			p1 -= 2
		}
		if thing[pos[i]-32] {
			p1 -= 2
		}
		if thing[pos[i]+32] {
			p1 -= 2
		}
		if thing[pos[i]-1] {
			p1 -= 2
		}
		if thing[pos[i]+1] {
			p1 -= 2
		}
	}
	mx++
	my++
	mz++
	todo := NewQueue(pos[0:])
	todo.Push(NewPos(mx, my, mz))
	visit := [32768]bool{}
	p2 := 0
	c := 0
	for !todo.Empty() {
		c++
		cur := todo.Pop()
		if visit[cur] {
			continue
		}
		visit[cur] = true
		x, y, z := cur.xyz()
		if thing[cur+1024] {
			p2++
		} else if !visit[cur+1024] && x < mx {
			todo.Push(cur + 1024)
		}
		if thing[cur-1024] {
			p2++
		} else if !visit[cur-1024] && x > 1 {
			todo.Push(cur - 1024)
		}
		if thing[cur+32] {
			p2++
		} else if !visit[cur+32] && y < my {
			todo.Push(cur + 32)
		}
		if thing[cur-32] {
			p2++
		} else if !visit[cur-32] && y > 1 {
			todo.Push(cur - 32)
		}
		if thing[cur+1] {
			p2++
		} else if !visit[cur+1] && z < mz {
			todo.Push(cur + 1)
		}
		if thing[cur-1] {
			p2++
		} else if !visit[cur-1] && z > 1 {
			todo.Push(cur - 1)
		}
	}
	return p1, p2
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
