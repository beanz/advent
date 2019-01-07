package main

import (
	//"fmt"
	"testing"

	. "github.com/beanz/advent-of-code-go"
)

func moveTest(t *testing.T, lines []string, x, y, ex, ey int) {
	g := readGame(lines, 3)
	player, ok := playerAt(g.players, x, y)
	if !ok {
		t.Errorf("a player should be at %d,%d", x, y)
		return
	}
	move(g, player)

	if player.x != ex || player.y != ey {
		t.Errorf("player should have moved to %d,%d not %d,%d",
			ex, ey, player.x, player.y)
	}
}

func TestMove4x1(t *testing.T) {
	moveTest(t,
		[]string{"#######", "#E..G.#", "#...#.#", "#.G.#G#", "#######"},
		4, 1, 3, 1)
}

func TestMove2x1a(t *testing.T) {
	moveTest(t,
		[]string{"#######", "#.E...#", "#.....#", "#...G.#", "#######"},
		2, 1, 3, 1)
}

func TestMove2x1b(t *testing.T) {
	moveTest(t,
		[]string{"#######", "#.G...#", "#....E#", "#E....#", "#######"},
		2, 1, 1, 1)
}

func TestMove4x5(t *testing.T) {
	moveTest(t,
		[]string{"#########", "#......G#", "#..#.##.#", "#..G....#", "#.#####.#", "#...E...#", "#########", ""},
		4, 5, 5, 5)
}

func TestMove5x2(t *testing.T) {
	moveTest(t,
		[]string{"###########", "#.G.#....G#", "###..E#####", "###########", ""},
		5, 2, 4, 2)
}

func testPart1(t *testing.T, l []string, exp int) {
	res := play1(l)
	if res != exp {
		t.Errorf("game part 1 outcome should be %d not %d\n", exp, res)
		return
	}
}

func testPart2(t *testing.T, l []string, exp int) {
	res := play2(l)
	if res != exp {
		t.Errorf("game part 2 outcome should be %d not %d\n", exp, res)
		return
	}
}

func TestGame0(t *testing.T) {
	l := []string{"#####", "#GEG#", "#####"}
	testPart1(t, l, 9933)
	testPart2(t, l, 920)
}

func TestGame1(t *testing.T) {
	l := []string{"#######", "#.G...#", "#...EG#", "#.#.#G#",
		"#..G#E#", "#.....#", "#######"}
	testPart1(t, l, 27730)
	testPart2(t, l, 4988)
}

func TestGame2(t *testing.T) {
	l := []string{"#######", "#G..#E#", "#E#E.E#", "#G.##.#",
		"#...#E#", "#...E.#", "#######"}
	testPart1(t, l, 36334)
	testPart2(t, l, 29064)
}

func TestGame3(t *testing.T) {
	l := []string{"#######", "#E..EG#", "#.#G.E#", "#E.##E#",
		"#G..#.#", "#..E#.#", "#######"}
	testPart1(t, l, 39514)
	testPart2(t, l, 31284)
}

func TestGame4(t *testing.T) {
	l := []string{"#######", "#E.G#.#", "#.#G..#", "#G.#.G#",
		"#G..#.#", "#...E.#", "#######"}
	testPart1(t, l, 27755)
	testPart2(t, l, 3478)
}

func TestGame5(t *testing.T) {
	l := []string{"#######", "#.E...#", "#.#..G#", "#.###.#",
		"#E#G#G#", "#...#G#", "#######"}
	testPart1(t, l, 28944)
	testPart2(t, l, 6474)
}

func TestGame6(t *testing.T) {
	l := []string{"#########", "#G......#", "#.E.#...#", "#..##..G#",
		"#...##..#", "#...#...#", "#.G...G.#", "#.....G.#", "#########"}
	testPart1(t, l, 18740)
	testPart2(t, l, 1140)
}

func TestGame7(t *testing.T) {
	l := ReadLines("input.txt")
	testPart1(t, l, 220480)
	testPart2(t, l, 53576)
}
