package main

import "testing"

func TestInRange(t *testing.T) {
	bot := &Bot{Point{0, 0, 0}, 4}
	for _, p := range []Point{
		Point{0, 0, 0}, Point{1, 0, 0}, Point{4, 0, 0},
		Point{0, 2, 0}, Point{0, 0, 3}, Point{1, 1, 1},
		Point{1, 1, 2}} {
		if !inRange(bot, p) {
			t.Errorf("Point %s should be in range of %s\n", p, bot)
		}
	}
}

func TestNotInRange(t *testing.T) {
	bot := &Bot{Point{0, 0, 0}, 4}
	for _, p := range []Point{Point{0, 5, 0}, Point{1, 3, 1}} {
		if inRange(bot, p) {
			t.Errorf("Point %s should not be in range of %s\n", p, bot)
		}
	}
}

func TestPlay1(t *testing.T) {
	s := "pos=<0,0,0>, r=4\npos=<1,0,0>, r=1\npos=<4,0,0>, r=3\n" +
		"pos=<0,2,0>, r=1\npos=<0,5,0>, r=3\npos=<0,0,3>, r=1\n" +
		"pos=<1,1,1>, r=1\npos=<1,1,2>, r=1\npos=<1,3,1>, r=1\n"
	game := readGame(s)
	res := play1(game)
	if res != 7 {
		t.Errorf("Expected 7 bots to be in range of most powerful\n")
	}
}

func TestCountInRange(t *testing.T) {
	p := Point{12, 12, 12}
	bots := []*Bot{
		&Bot{Point{10, 12, 12}, 2},
		&Bot{Point{12, 14, 12}, 2},
		&Bot{Point{16, 12, 12}, 4},
		&Bot{Point{14, 14, 14}, 6},
		&Bot{Point{50, 50, 50}, 200},
		&Bot{Point{10, 10, 10}, 5},
	}
	res := countInRange(bots, p)
	if res != 5 {
		t.Errorf("Point %s should be in range of 5 bots not %d\n", p, res)
	}
}

func TestPlay2(t *testing.T) {
	s := "pos=<10,12,12>, r=2\npos=<12,14,12>, r=2\npos=<16,12,12>, r=4\n" +
		"pos=<14,14,14>, r=6\npos=<50,50,50>, r=200\npos=<10,10,10>, r=5\n"
	game := readGame(s)
	res := play2(game)
	if res != 36 {
		t.Errorf("Expected point of distance 36 to be found not %d\n", res)
	}
}
