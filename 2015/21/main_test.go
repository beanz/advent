package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestAttack(t *testing.T) {
	assert.Equal(t, 3, Attack(5, 2), "attack 5 damage against 2 armor")
	assert.Equal(t, 1, Attack(5, 10), "attack 5 damage against 10 armor")
	assert.Equal(t, 2, Attack(7, 5), "attack 7 damage against 5 armor")
}

func TestTimeToDeath(t *testing.T) {
	assert.Equal(t, 4, TimeToDeath(12, 5, 2), "ttd 12hp 5dam 2 armor")
	assert.Equal(t, 4, TimeToDeath(8, 7, 5), "ttd 12hp 5dam 2 armor")
}

func TestBattle(t *testing.T) {
	b := Battle{player: Fighter{hp: 8, damage: 5, armor: 5},
		enemy: Fighter{hp: 12, damage: 7, armor: 2}}
	assert.Equal(t, Player, b.Victory(), "battle victory?")
}

func TestParts(t *testing.T) {
	g := NewGame(ReadFileInts("input.txt"))
	p1, p2 := g.Calc()
	assert.Equal(t, 121, p1, "part 1")
	assert.Equal(t, 201, p2, "part 2")
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
