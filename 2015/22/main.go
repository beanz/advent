package main

import (
	_ "embed"
	"fmt"
	"math"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Spell int

const (
	MagicMissile Spell = iota
	Drain
	Shield
	Poison
	Recharge
)

func (s Spell) String() string {
	switch s {
	case MagicMissile:
		return "Magic Missile"
	case Drain:
		return "Drain"
	case Shield:
		return "Shield"
	case Poison:
		return "Poison"
	case Recharge:
		return "Recharge"
	default:
		return "Unknown Spell"
	}
}

func (s Spell) Cost() int {
	switch s {
	case MagicMissile:
		return 53
	case Drain:
		return 73
	case Shield:
		return 113
	case Poison:
		return 173
	case Recharge:
		return 229
	default:
		return 0
	}
}

func (s Spell) Damage() int {
	switch s {
	case MagicMissile:
		return 4
	case Drain:
		return 2
	case Poison:
		return 3
	default:
		return 0
	}
}

func (s Spell) Turns() int {
	switch s {
	case Shield:
		return 6
	case Poison:
		return 6
	case Recharge:
		return 5
	default:
		return 0
	}
}

func (s Spell) Heal() int {
	switch s {
	case Drain:
		return 2
	default:
		return 0
	}
}

func (s Spell) Mana() int {
	switch s {
	case Recharge:
		return 101
	default:
		return 0
	}
}

func (s Spell) Armor() int {
	if s == Shield {
		return 7
	}
	return 0
}

var AllSpells = []Spell{MagicMissile, Drain, Shield, Poison, Recharge}

// Shield       = Spell{name: "Shield", cost: 113, turns: 6, armor: 7}
// MagicMissile = Spell{name: "Magic Missile", cost: 53, damage: 4}
// Drain        = Spell{name: "Drain", cost: 73, damage: 2, heal: 2}
// Poison       = Spell{name: "Poison", cost: 173, turns: 6, damage: 3}
// Recharge     = Spell{name: "Recharge", cost: 229, turns: 5, mana: 101}

type ActiveSpells map[Spell]int

type Me struct {
	hp        int
	armor     int
	mana      int
	manaSpent int
	active    ActiveSpells
}

type Boss struct {
	hp, damage int
}

type Game struct {
	bossHp, bossDamage int
	part2              bool
	debug              bool
}

func NewGame(in []int) *Game {
	return &Game{
		bossHp:     in[0],
		bossDamage: in[1],
		debug:      false,
	}
}

type State struct {
	me    *Me
	boss  *Boss
	debug bool
}

func (s *State) Clone() *State {
	nm := Me{
		hp: s.me.hp, armor: s.me.armor, mana: s.me.mana,
		manaSpent: s.me.manaSpent,
		active:    make(map[Spell]int, len(s.me.active)),
	}
	for k, v := range s.me.active {
		nm.active[k] = v
	}
	return &State{
		me:    &nm,
		boss:  &Boss{hp: s.boss.hp, damage: s.boss.damage},
		debug: s.debug}
}

func (s *State) Turn(sp Spell) {
	if s.debug {
		fmt.Printf("-- Player turn --\n")
		fmt.Printf("- Player has %d hit points, %d armor, %d mana\n",
			s.me.hp, s.me.armor, s.me.mana)
		fmt.Printf("- Boss has %d hit points\n", s.boss.hp)
	}
	for k := range s.me.active {
		s.me.hp += k.Heal()
		s.me.mana += k.Mana()
		s.boss.hp -= k.Damage()
		s.me.active[k]--
		if s.debug {
			fmt.Printf("%s active\n", k)
		}
		if s.me.active[k] == 0 {
			if k.Armor() != 0 {
				s.me.armor -= k.Armor()
			}
			if s.debug {
				fmt.Printf("%s wears off\n", k)
			}
			delete(s.me.active, k)
		}
	}
	s.me.mana -= sp.Cost()
	s.me.manaSpent += sp.Cost()

	if sp.Turns() > 0 {
		if s.debug {
			fmt.Printf("Player casts %s\n", sp)
		}
		s.me.active[sp] = sp.Turns()
		if sp.Armor() != 0 {
			s.me.armor += sp.Armor()
		}
	} else {
		if s.debug {
			fmt.Printf("Player casts %s with instant effects\n", sp)
		}
		s.me.hp += sp.Heal()
		s.me.mana += sp.Mana()
		s.boss.hp -= sp.Damage()
	}
	if s.boss.hp <= 0 {
		if s.debug {
			fmt.Printf("Boss is dead\n")
		}
		return
	}

	if s.debug {
		fmt.Printf("\n")
		fmt.Printf("-- Boss turn --\n")
		fmt.Printf("- Player has %d hit points, %d armor, %d mana\n",
			s.me.hp, s.me.armor, s.me.mana)
		fmt.Printf("- Boss has %d hit points\n", s.boss.hp)
	}
	for k := range s.me.active {
		s.me.hp += k.Heal()
		s.me.mana += k.Mana()
		s.boss.hp -= k.Damage()
		s.me.active[k]--
		if s.debug {
			fmt.Printf("%s active (%d)\n", k, s.me.active[k])
		}
		if s.me.active[k] == 0 {
			if k.Armor() != 0 {
				s.me.armor -= k.Armor()
			}
			if s.debug {
				fmt.Printf("%s wears off\n", k)
			}
			delete(s.me.active, k)
		}
	}
	if s.boss.hp <= 0 {
		if s.debug {
			fmt.Printf("Boss is dead\n")
		}
		return
	}
	damage := MaxInt(1, s.boss.damage-s.me.armor)
	if s.debug {
		fmt.Printf("Boss attacks for %d damage\n\n", damage)
	}
	s.me.hp -= damage
	if s.me.hp <= 0 {
		if s.debug {
			fmt.Printf("Player is dead\n")
		}
	}
}

func (g *Game) Calc(hardMode bool) int {
	minCost := math.MaxInt32
	todo := []*State{&State{
		&Me{hp: 50, mana: 500, active: make(map[Spell]int)},
		&Boss{hp: g.bossHp, damage: g.bossDamage},
		g.debug,
	}}
	for len(todo) > 0 {
		cur := todo[0]
		todo = todo[1:]

		if hardMode {
			cur.me.hp--
			if cur.me.hp <= 0 {
				continue
			}
		}
		for _, spell := range AllSpells {
			if cur.me.active[spell] > 1 {
				continue // currently active
			}
			if cur.me.mana < spell.Cost() {
				continue // can't afford spell
			}

			new := cur.Clone()
			new.Turn(spell)
			if new.boss.hp <= 0 {
				if g.debug {
					fmt.Printf("Player wins %d (%d)\n",
						new.me.manaSpent, minCost)
				}
				if minCost > new.me.manaSpent {
					minCost = new.me.manaSpent
				}
				continue
			}
			if new.me.hp <= 0 {
				continue
			}
			todo = append(todo, new)
		}

	}
	return minCost
}

func (g *Game) Part1() int {
	return g.Calc(false)
}

func (g *Game) Part2() int {
	return g.Calc(true)
}

func main() {
	in := InputInts(input)
	g := NewGame(in)
	p1 := g.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := g.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark bool
