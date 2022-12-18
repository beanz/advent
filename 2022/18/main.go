package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Pos struct {
	x, y, z int
}

func (p Pos) Key() int {
	return (p.x+2)<<10 + (p.y+2)<<5 + (p.z + 2)
}

func Parts(in []byte) (int, int) {
	pos := make([]Pos, 0, 7680)
	min := Pos{10000, 10000, 10000}
	max := Pos{0, 0, 0}
	for i := 0; i < len(in); {
		j, p := NextPos(in, i)
		pos = append(pos, p)
		if min.x > p.x {
			min.x = p.x
		}
		if max.x < p.x {
			max.x = p.x
		}
		if min.y > p.y {
			min.y = p.y
		}
		if max.y < p.y {
			max.y = p.y
		}
		if min.z > p.z {
			min.z = p.z
		}
		if max.z < p.z {
			max.z = p.z
		}
		i = j
	}
	p1 := 6 * len(pos)
	thing := [32768]bool{}
	for i := 0; i < len(pos); i++ {
		thing[pos[i].Key()] = true
		for j := i + 1; j < len(pos); j++ {
			eqx, eqy, eqz := pos[i].x == pos[j].x, pos[i].y == pos[j].y, pos[i].z == pos[j].z
			if eqx {
				if eqy && (pos[i].z == pos[j].z-1 || pos[i].z == pos[j].z+1) {
					p1 -= 2
				}
				if eqz && (pos[i].y == pos[j].y-1 || pos[i].y == pos[j].y+1) {
					p1 -= 2
				}
			} else {
				if eqy && eqz && (pos[i].x == pos[j].x-1 || pos[i].x == pos[j].x+1) {
					p1 -= 2
				}
			}
		}
	}
	min.x--
	min.y--
	min.z--
	max.x++
	max.y++
	max.z++
	todo := make([]Pos, 0, 768)
	todo = append(todo, Pos{max.x, max.y, max.z})
	visit := [32768]bool{}
	p2 := 0
	for len(todo) != 0 {
		cur := todo[0]
		todo = todo[1:]
		key := cur.Key()
		if thing[key] {
			continue
		}
		if visit[key] {
			continue
		}
		visit[key] = true
		n := Pos{cur.x + 1, cur.y, cur.z}
		nk := n.Key()
		if thing[nk] {
			p2++
		} else if !visit[nk] && cur.x < max.x {
			todo = append(todo, n)
		}
		n = Pos{cur.x - 1, cur.y, cur.z}
		nk = n.Key()
		if thing[nk] {
			p2++
		} else if !visit[nk] && cur.x > min.x {
			todo = append(todo, n)
		}
		n = Pos{cur.x, cur.y + 1, cur.z}
		nk = n.Key()
		if thing[nk] {
			p2++
		} else if !visit[nk] && cur.y < max.y {
			todo = append(todo, n)
		}
		n = Pos{cur.x, cur.y - 1, cur.z}
		nk = n.Key()
		if thing[nk] {
			p2++
		} else if !visit[nk] && cur.y > min.y {
			todo = append(todo, n)
		}
		n = Pos{cur.x, cur.y, cur.z + 1}
		nk = n.Key()
		if thing[nk] {
			p2++
		} else if !visit[nk] && cur.z < max.z {
			todo = append(todo, n)
		}
		n = Pos{cur.x, cur.y, cur.z - 1}
		nk = n.Key()
		if thing[nk] {
			p2++
		} else if !visit[nk] && cur.z > min.z {
			todo = append(todo, n)
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

func NextPos(in []byte, i int) (int, Pos) {
	j, x := NextUInt(in, i)
	j++
	j, y := NextUInt(in, j)
	j++
	j, z := NextUInt(in, j)
	return j + 1, Pos{x, y, z}
}

func NextUInt(in []byte, i int) (j int, n int) {
	j = i
	for ; '0' <= in[j] && in[j] <= '9'; j++ {
		n = 10*n + int(in[j]-'0')
	}
	return
}

var benchmark = false
