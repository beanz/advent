package main

import (
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
	"strings"
)

//go:embed input.txt
var input []byte

type Scanner struct {
	beacons []*Point3D
	pos     *Point3D
	rotated [][]*Point3D
}

type Game struct {
	scanners []*Scanner
	beacons  map[Point3D]bool
}

func NewGame(in []byte) *Game {
	chunks := strings.Split(string(in), "\n\n")
	g := &Game{
		make([]*Scanner, 0, len(chunks)),
		make(map[Point3D]bool, 512),
	}
	for _, ch := range chunks {
		s := strings.SplitN(ch, "\n", 2)
		ints := FastSignedInts([]byte(s[1]), 128)
		points := make([]*Point3D, 0, 32)
		for i := 0; i < len(ints); i += 3 {
			points = append(points, &Point3D{ints[i], ints[i+1], ints[i+2]})
		}
		scanner := &Scanner{points, nil, make([][]*Point3D, 24)}
		for r := 0; r < 24; r++ {
			scanner.rotated[r] = make([]*Point3D, len(points))
			for i := 0; i < len(points); i++ {
				scanner.rotated[r][i] = Rotate(points[i], r)
			}
		}
		g.scanners = append(g.scanners, scanner)
	}
	for _, b := range g.scanners[0].beacons {
		g.beacons[*b] = true
	}
	g.scanners[0].pos = &Point3D{0, 0, 0}
	return g
}

func Rotate(b *Point3D, rotation int) *Point3D {
	switch rotation {
	case 0:
		return &Point3D{b.X, b.Y, b.Z}
	case 1:
		return &Point3D{b.X, b.Z, -b.Y}
	case 2:
		return &Point3D{b.X, -b.Y, -b.Z}
	case 3:
		return &Point3D{b.X, -b.Z, b.Y}
	case 4:
		return &Point3D{b.Y, -b.X, b.Z}
	case 5:
		return &Point3D{b.Y, b.Z, b.X}
	case 6:
		return &Point3D{b.Y, b.X, -b.Z}
	case 7:
		return &Point3D{b.Y, -b.Z, -b.X}
	case 8:
		return &Point3D{-b.X, -b.Y, b.Z}
	case 9:
		return &Point3D{-b.X, -b.Z, -b.Y}
	case 10:
		return &Point3D{-b.X, b.Y, -b.Z}
	case 11:
		return &Point3D{-b.X, b.Z, b.Y}
	case 12:
		return &Point3D{-b.Y, b.X, b.Z}
	case 13:
		return &Point3D{-b.Y, -b.Z, b.X}
	case 14:
		return &Point3D{-b.Y, -b.X, -b.Z}
	case 15:
		return &Point3D{-b.Y, b.Z, -b.X}
	case 16:
		return &Point3D{b.Z, b.Y, -b.X}
	case 17:
		return &Point3D{b.Z, b.X, b.Y}
	case 18:
		return &Point3D{b.Z, -b.Y, b.X}
	case 19:
		return &Point3D{b.Z, -b.X, -b.Y}
	case 20:
		return &Point3D{-b.Z, -b.Y, -b.X}
	case 21:
		return &Point3D{-b.Z, -b.X, b.Y}
	case 22:
		return &Point3D{-b.Z, b.Y, b.X}
	case 23:
		return &Point3D{-b.Z, b.X, -b.Y}
	default:
		panic("invalid rotation")
	}
}

func (g *Game) align(i int) bool {
	//fmt.Printf("trying to align scanner %d\n", i)
	alloc := make([]*Point3D, 0, 32)
	for known := range g.beacons {
		//for _, known := range  g.scanners[0].beacons {
		for bi := range g.scanners[i].beacons {
			//fmt.Printf("assuming %s == [%d] %s\n", known, bi, beacon)
			for ri := 0; ri < 24; ri++ {
				rbeacon := g.scanners[i].rotated[ri][bi]
				//fmt.Printf("rotation %d *> %s\n", ri, rbeacon)
				transform := Point3D{
					known.X - rbeacon.X,
					known.Y - rbeacon.Y,
					known.Z - rbeacon.Z,
				}
				//fmt.Printf("transform %s\n", transform)
				c := 0
				nb := alloc[:0]
				for obi := range g.scanners[i].beacons {
					if obi == bi {
						continue
					}
					robeacon := g.scanners[i].rotated[ri][obi]
					trobeacon := Point3D{
						robeacon.X + transform.X,
						robeacon.Y + transform.Y,
						robeacon.Z + transform.Z,
					}
					//fmt.Printf("ro=%s tro=%s\n", robeacon, trobeacon)
					if _, ok := g.beacons[trobeacon]; ok {
						//fmt.Printf("matched %s\n", trobeacon)
						c++
					} else {
						nb = append(nb, &trobeacon)
					}
				}
				if c >= 11 {
					//fmt.Printf("found %d rotation %d %s\n",
					//    c, ri, transform)
					g.scanners[i].pos = &transform
					for _, b := range nb {
						g.beacons[*b] = true
					}
					return true
				}
			}
		}
	}
	return false
}

func (g *Game) Solve() (int, int) {
	todo := len(g.scanners) - 1
	for todo > 0 {
		for i := 1; i < len(g.scanners); i++ {
			if g.scanners[i].pos != nil {
				continue
			}
			if g.align(i) {
				todo--
			}
		}
	}
	max := 0
	for i := 0; i < len(g.scanners); i++ {
		for j := i + 1; j < len(g.scanners); j++ {
			md := g.scanners[i].pos.ManhattanDistance(*g.scanners[j].pos)
			if md > max {
				max = md
			}
		}

	}
	return len(g.beacons), max
}

func main() {
	g := NewGame(InputBytes(input))
	p1, p2 := g.Solve()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
