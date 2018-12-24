package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestParseGroup1(t *testing.T) {
	line := `17 units each with 5390 hit points (weak to radiation, bludgeoning) with an attack that does 4507 fire damage at initiative 2`
	group := parseGroup(line, "Team Foo", 1)
	assert.Equal(t, "Team Foo group 1", group.Name(), "Group name")
	assert.Equal(t, Units(17), group.units, "Group units should be parsed")
	assert.Equal(t, 5390, group.hp, "HP units should be parsed")
	assert.Equal(t, 4507, group.attackDamage, "Damage should be parsed")
	assert.Equal(t, "fire", group.attackType, "Damage type should be parsed")
	assert.Equal(t, 2, group.initiative, "Initiative should be parsed")
	assert.True(t, group.WeakTo("radiation"), "Weak to radiation")
	assert.True(t, group.WeakTo("bludgeoning"), "Weak to bludgeoning")
	assert.False(t, group.WeakTo("fire"), "Not weak to fire")
	assert.False(t, group.ImmuneTo("sneezing"), "Not immune to sneezing")

	assert.Equal(t, 76619, group.EffectivePower(),
		"Effective power should be calculated")
	assert.True(t, group.Alive(), "Group should be alive")
	assert.Equal(t, "Immune System", group.Enemy(), "Enemy should be default")
}

func TestParseGroup2(t *testing.T) {
	line := `4485 units each with 2961 hit points (immune to radiation; weak to fire, cold) with an attack that does 12 slashing damage at initiative 4`
	group := parseGroup(line, "Immune System", 4)
	assert.Equal(t, "Immune System group 4", group.Name(), "Group name")
	assert.Equal(t, Units(4485), group.units, "Group units should be parsed")
	assert.Equal(t, 2961, group.hp, "HP units should be parsed")
	assert.Equal(t, 12, group.attackDamage, "Damage should be parsed")
	assert.Equal(t, "slashing", group.attackType,
		"Damage type should be parsed")
	assert.Equal(t, 4, group.initiative, "Initiative should be parsed")
	assert.True(t, group.WeakTo("fire"), "Weak to radiation")
	assert.True(t, group.WeakTo("cold"), "Weak to bludgeoning")
	assert.False(t, group.WeakTo("slashing"), "Not weak to fire")
	assert.True(t, group.ImmuneTo("radiation"), "Immune to radiation")
	assert.False(t, group.ImmuneTo("sneezing"), "Not immune to sneezing")

	assert.Equal(t, 53820, group.EffectivePower(),
		"Effective power should be calculated")
	assert.True(t, group.Alive(), "Group should be alive")
	assert.Equal(t, "Infection", group.Enemy(), "Enemy should be infection")
}

func TestPlay1(t *testing.T) {
	s := `Immune System:
17 units each with 5390 hit points (weak to radiation, bludgeoning) with
 an attack that does 4507 fire damage at initiative 2
989 units each with 1274 hit points (immune to fire; weak to bludgeoning,
 slashing) with an attack that does 25 slashing damage at initiative 3

Infection:
801 units each with 4706 hit points (weak to radiation) with an attack
 that does 116 bludgeoning damage at initiative 1
4485 units each with 2961 hit points (immune to radiation; weak to fire,
 cold) with an attack that does 12 slashing damage at initiative 4
`

	game := readGame(s)

	groups := game.TargetSelectionGroups()
	assert.Equal(t, "Infection group 1", groups[0].Name(),
		"Target selection order first group should be Infection group 1")
	assert.Equal(t, "Immune System group 1", groups[1].Name(),
		"Target selection order second group should be Immune System group 1")
	assert.Equal(t, "Infection group 2", groups[2].Name(),
		"Target selection order third group should be Infection group 2")
	assert.Equal(t, "Immune System group 2", groups[3].Name(),
		"Target selection order fourth group should be Immune System group 2")

	targets := game.TargetSelection()
	assert.Equal(t, "Immune System group 1", targets[groups[0]].Name(),
		"Infection group 1 targets Immune System group 1")
	assert.Equal(t, "Infection group 2", targets[groups[1]].Name(),
		"Immune System group 1 targets Infection group 2")
	assert.Equal(t, "Immune System group 2", targets[groups[2]].Name(),
		"Infection group 2 targets Immune System group 2")
	assert.Equal(t, "Infection group 1", targets[groups[3]].Name(),
		"Immune System group 2 targets Infection group 1")

	counts := game.UnitCounts()
	assert.Equal(t, 1006, counts["Immune System"], "Immune System unit count should be calculated")
	assert.Equal(t, 5286, counts["Infection"], "Infection unit count should be calculated")
	assert.Equal(t, 6292, counts["Total"], "Total unit count should be calculated")

	game.Attacks(targets)
	assert.Equal(t, 0, int(groups[1].units),
		"Immune System group 1 should have no units")
	assert.Equal(t, 905, int(groups[3].units),
		"Immune System group 2 should still have units")
	assert.Equal(t, 797, int(groups[0].units),
		"Infection group 1 should still have units")
	assert.Equal(t, 4434, int(groups[2].units),
		"Infection group 2 should still have units")

	res := game.Part1()
	if res != 5216 {
		t.Errorf("Expected 5216 units remaining\n")
	}
}

func TestPlay2(t *testing.T) {
	s := `Immune System:
17 units each with 5390 hit points (weak to radiation, bludgeoning) with
 an attack that does 4507 fire damage at initiative 2
989 units each with 1274 hit points (immune to fire; weak to bludgeoning,
 slashing) with an attack that does 25 slashing damage at initiative 3

Infection:
801 units each with 4706 hit points (weak to radiation) with an attack
 that does 116 bludgeoning damage at initiative 1
4485 units each with 2961 hit points (immune to radiation; weak to fire,
 cold) with an attack that does 12 slashing damage at initiative 4
`

	game := readGame(s)
	game.SetBoost(1570)
	counts := game.Play()
	assert.Equal(t, 51, counts["Immune System"], "Immune System should win")

	game.Reset()
	game.SetBoost(1569)
	counts = game.Play()
	assert.Equal(t, 139, counts["Infection"], "Infection should win")
}
