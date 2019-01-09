package aoc

import (
	"fmt"
	"log"
)

type Compass string

type Direction struct {
	Dx, Dy int
}

func (d Direction) String() string {
	return fmt.Sprintf("[%d,%d]", d.Dx, d.Dy)
}

func (d Direction) CCW() Direction {
	switch {
	case d.Dx == 0 && d.Dy == -1:
		return Direction{-1, 0}
	case d.Dx == 1 && d.Dy == 0:
		return Direction{0, -1}
	case d.Dx == 0 && d.Dy == 1:
		return Direction{1, 0}
	case d.Dx == -1 && d.Dy == 0:
		return Direction{0, 1}
	}
	return Direction{0, 0}
}

func (d Direction) CW() Direction {
	switch {
	case d.Dx == 0 && d.Dy == -1:
		return Direction{1, 0}
	case d.Dx == 1 && d.Dy == 0:
		return Direction{0, 1}
	case d.Dx == 0 && d.Dy == 1:
		return Direction{-1, 0}
	case d.Dx == -1 && d.Dy == 0:
		return Direction{0, -1}
	}
	return Direction{0, 0}
}

func (d Direction) Compass() Compass {
	switch {
	case d.Dx == 0 && d.Dy == -1:
		return "N"
	case d.Dx == 1 && d.Dy == 0:
		return "E"
	case d.Dx == 0 && d.Dy == 1:
		return "S"
	case d.Dx == -1 && d.Dy == 0:
		return "W"
	case d.Dx == 1 && d.Dy == -1:
		return "NE"
	case d.Dx == 1 && d.Dy == 1:
		return "SE"
	case d.Dx == -1 && d.Dy == 1:
		return "SW"
	case d.Dx == -1 && d.Dy == -1:
		return "NW"
	default:
		log.Fatalf("Invalid direction [%d,%d]\n", d.Dx, d.Dy)
		return "X"
	}
}

func (d Direction) Opposite() Direction {
	return Direction{d.Dx * -1, d.Dy * -1}
}

func (c Compass) Opposite() Compass {
	return c.Direction().Opposite().Compass()
}

func (c Compass) Direction() Direction {
	switch c {
	case "N":
		return Direction{0, -1}
	case "E":
		return Direction{1, 0}
	case "S":
		return Direction{0, 1}
	case "W":
		return Direction{-1, 0}
	case "NE":
		return Direction{1, -1}
	case "SE":
		return Direction{1, 1}
	case "SW":
		return Direction{-1, 1}
	case "NW":
		return Direction{-1, -1}
	default:
		log.Fatalf("Invalid compass direction %s\n", c)
		return Direction{0, 0}
	}
}
