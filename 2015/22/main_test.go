package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestTurnsExample1(t *testing.T) {
	s := &State{
		&Me{hp: 10, mana: 250, active: make(map[Spell]int)},
		&Boss{hp: 13, damage: 8},
		false,
	}
	s.Turn(Poison)
	assert.Equal(t, 10, s.boss.hp, "T1&2 boss hp")
	assert.Equal(t, 2, s.me.hp, "T1&2 player hp")
	assert.Equal(t, 0, s.me.armor, "T1&2 player armor")
	assert.Equal(t, 77, s.me.mana, "T1&2 player mana")
	assert.Equal(t, 173, s.me.manaSpent, "T1&2 player mana spent")
	s.Turn(MagicMissile)
	assert.Equal(t, 0, s.boss.hp, "T3&4 boss hp")
	assert.Equal(t, 2, s.me.hp, "T3&4 player hp")
	assert.Equal(t, 0, s.me.armor, "T3&4 player armor")
	assert.Equal(t, 24, s.me.mana, "T3&4 player mana")
	assert.Equal(t, 226, s.me.manaSpent, "T3&4 player mana spent")
}

func TestTurnsExample2(t *testing.T) {
	s := &State{
		&Me{hp: 10, mana: 250, active: make(map[Spell]int)},
		&Boss{hp: 14, damage: 8},
		false,
	}
	s.Turn(Recharge)
	assert.Equal(t, 14, s.boss.hp, "T1&2 boss hp")
	assert.Equal(t, 2, s.me.hp, "T1&2 player hp")
	assert.Equal(t, 0, s.me.armor, "T1&2 player armor")
	assert.Equal(t, 122, s.me.mana, "T1&2 player mana")
	assert.Equal(t, 229, s.me.manaSpent, "T1&2 player mana spent")

	s.Turn(Shield)
	assert.Equal(t, 14, s.boss.hp, "T3&4 boss hp")
	assert.Equal(t, 1, s.me.hp, "T3&4 player hp")
	assert.Equal(t, 7, s.me.armor, "T3&4 player armor")
	assert.Equal(t, 211, s.me.mana, "T3&4 player mana")
	assert.Equal(t, 229+113, s.me.manaSpent, "T3&4 player mana spent")

	s.Turn(Drain)
	assert.Equal(t, 12, s.boss.hp, "T5&6 boss hp")
	assert.Equal(t, 2, s.me.hp, "T5&6 player hp")
	assert.Equal(t, 7, s.me.armor, "T5&6 player armor")
	assert.Equal(t, 340, s.me.mana, "T5&6 player mana")
	assert.Equal(t, 229+113+73, s.me.manaSpent, "T5&6 player mana spent")

	s.Turn(Poison)
	assert.Equal(t, 9, s.boss.hp, "T7&8 boss hp")
	assert.Equal(t, 1, s.me.hp, "T7&8 player hp")
	assert.Equal(t, 7, s.me.armor, "T7&8 player armor")
	assert.Equal(t, 167, s.me.mana, "T7&8 player mana")
	assert.Equal(t, 229+113+73+173, s.me.manaSpent,
		"T7&8 player mana spent")

	s.Turn(MagicMissile)
	assert.Equal(t, -1, s.boss.hp, "T9&10 boss hp")
	assert.Equal(t, 1, s.me.hp, "T9&10 player hp")
	assert.Equal(t, 0, s.me.armor, "T9&10 player armor")
	assert.Equal(t, 114, s.me.mana, "T9&10 player mana")
	assert.Equal(t, 229+113+73+173+53, s.me.manaSpent,
		"T9&10 player mana spent")
}

func TestTurnsExample3(t *testing.T) {
	s := &State{
		&Me{hp: 10, mana: 250, active: make(map[Spell]int)},
		&Boss{hp: 20, damage: 8},
		false,
	}
	s.Turn(Poison)
	assert.Equal(t, 17, s.boss.hp, "T1&2 boss hp")
	assert.Equal(t, 2, s.me.hp, "T1&2 player hp")
	assert.Equal(t, 0, s.me.armor, "T1&2 player armor")
	assert.Equal(t, 77, s.me.mana, "T1&2 player mana")
	assert.Equal(t, 173, s.me.manaSpent, "T1&2 player mana spent")

	s.Turn(MagicMissile)
	assert.Equal(t, 7, s.boss.hp, "T3&4 boss hp")
	assert.Equal(t, -6, s.me.hp, "T3&4 player hp")
	assert.Equal(t, 0, s.me.armor, "T3&4 player armor")
	assert.Equal(t, 24, s.me.mana, "T3&4 player mana")
	assert.Equal(t, 173+53, s.me.manaSpent, "T3&4 player mana spent")
}

func TestParts(t *testing.T) {
	g := NewGame(ReadFileInts("input.txt"))
	assert.Equal(t, 1824, g.Part1(), "part 1")
	assert.Equal(t, 1937, g.Part2(), "part 2")
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
