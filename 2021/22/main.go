package main

import (
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
	"strings"
)

//go:embed input.txt
var input []byte

type Cuboid struct {
	xmin, xmax, ymin, ymax, zmin, zmax int
	value                              bool
}

func NewCuboid(value bool, dim ...int) *Cuboid {
	// increment the max values to make ranges checking easier
	return &Cuboid{dim[0], dim[1] + 1, dim[2], dim[3] + 1, dim[4], dim[5] + 1, value}
}

func (c *Cuboid) Value() bool {
	return c.value
}

func (c *Cuboid) String() string {
	val := "off"
	if c.value {
		val = "on"
	}
	return fmt.Sprintf("%s %d..%d %d..%d %d..%d",
		val, c.xmin, c.xmax, c.ymin, c.ymax, c.zmin, c.zmax)
}

func (c *Cuboid) Volume() int {
	return (c.xmax - c.xmin) * (c.ymax - c.ymin) * (c.zmax - c.zmin)
}

func (c0 *Cuboid) Contains(c1 *Cuboid) bool {
	return c0.xmin <= c1.xmin && c0.xmax >= c1.xmax &&
		c0.ymin <= c1.ymin && c0.ymax >= c1.ymax &&
		c0.zmin <= c1.zmin && c0.zmax >= c1.zmax
}

func (c0 *Cuboid) Intersects(c1 *Cuboid) bool {
	return c0.xmin <= c1.xmax && c0.xmax >= c1.xmin &&
		c0.ymin <= c1.ymax && c0.ymax >= c1.ymin &&
		c0.zmin <= c1.zmax && c0.zmax >= c1.zmin
}

func (c0 *Cuboid) Intersection(c1 *Cuboid) *Cuboid {
	if !c0.Intersects(c1) {
		return nil
	}
	return &Cuboid{
		MaxInt(c0.xmin, c1.xmin), MinInt(c0.xmax, c1.xmax),
		MaxInt(c0.ymin, c1.ymin), MinInt(c0.ymax, c1.ymax),
		MaxInt(c0.zmin, c1.zmin), MinInt(c0.zmax, c1.zmax),
		c0.value,
	}
}

func (c0 *Cuboid) Difference(c1 *Cuboid) []*Cuboid {
	if c1.Contains(c0) {
		return []*Cuboid{}
	}
	if !c0.Intersects(c1) {
		return []*Cuboid{c0}
	}
	x := make([]int, 0, 4)
	x = append(x, c0.xmin)
	if c0.xmin < c1.xmin && c1.xmin < c0.xmax {
		x = append(x, c1.xmin)
	}
	if c0.xmin < c1.xmax && c1.xmax < c0.xmax {
		x = append(x, c1.xmax)
	}
	x = append(x, c0.xmax)

	y := make([]int, 0, 4)
	y = append(y, c0.ymin)
	if c0.ymin < c1.ymin && c1.ymin < c0.ymax {
		y = append(y, c1.ymin)
	}
	if c0.ymin < c1.ymax && c1.ymax < c0.ymax {
		y = append(y, c1.ymax)
	}
	y = append(y, c0.ymax)

	z := make([]int, 0, 4)
	z = append(z, c0.zmin)
	if c0.zmin < c1.zmin && c1.zmin < c0.zmax {
		z = append(z, c1.zmin)
	}
	if c0.zmin < c1.zmax && c1.zmax < c0.zmax {
		z = append(z, c1.zmax)
	}
	z = append(z, c0.zmax)
	res := make([]*Cuboid, 0, 27)
	for xi := 0; xi < len(x)-1; xi++ {
		for yi := 0; yi < len(y)-1; yi++ {
			for zi := 0; zi < len(z)-1; zi++ {
				n := &Cuboid{
					x[xi], x[xi+1],
					y[yi], y[yi+1],
					z[zi], z[zi+1],
					c0.value,
				}
				if !c1.Contains(n) {
					res = append(res, n)
				}
			}
		}
	}
	return res
}

type Reactor struct {
	cuboids []*Cuboid
}

func NewReactor(in []byte) *Reactor {
	cuboids := make([]*Cuboid, 0, 512)
	j := 0
	for i := 0; i < len(in); i++ {
		if in[i] == '\n' {
			dim := FastSignedInts(in[j:i], 6)
			var val bool
			if in[j+1] == 'n' {
				val = true
			}
			j = i + 1
			cuboids = append(cuboids, NewCuboid(val, dim...))
		}
	}
	return &Reactor{cuboids}
}

func (r *Reactor) String() string {
	var sb strings.Builder
	for _, c := range r.cuboids {
		sb.WriteString(c.String())
		sb.WriteByte('\n')
	}
	return sb.String()
}

func (r *Reactor) Reboot() (int, int) {
	cuboids := make([]*Cuboid, 0, len(r.cuboids)*27)
	next := make([]*Cuboid, 0, len(r.cuboids)*27)
	for _, c := range r.cuboids {
		for _, old := range cuboids {
			diff := old.Difference(c)
			next = append(next, diff...)
		}
		if c.Value() {
			next = append(next, c)
		}
		cuboids, next = next, cuboids[:0]
	}
	p1, p2 := 0, 0
	p1c := NewCuboid(true, -50, 51, -50, 51, -50, 51)
	for _, c := range cuboids {
		p2 += c.Volume()
		if intersection := c.Intersection(p1c); intersection != nil {
			p1 += intersection.Volume()
		}
	}
	return p1, p2
}

func main() {
	g := NewReactor(InputBytes(input))
	p1, p2 := g.Reboot()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
