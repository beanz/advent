const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Spell = struct {
    cost: u8,
    damage: i8,
    heal: i8,
    armor: i8,
    mana: i8,
    turns: u3,
};

const spells: [5]Spell = .{
    Spell{ .cost = 53, .damage = 4, .heal = 0, .armor = 0, .mana = 0, .turns = 0 },
    Spell{ .cost = 73, .damage = 2, .heal = 2, .armor = 0, .mana = 0, .turns = 0 },
    Spell{ .cost = 113, .damage = 0, .heal = 0, .armor = 7, .mana = 0, .turns = 6 },
    Spell{ .cost = 173, .damage = 3, .heal = 0, .armor = 0, .mana = 0, .turns = 6 },
    Spell{ .cost = 229, .damage = 0, .heal = 0, .armor = 0, .mana = 101, .turns = 5 },
};

const State = struct {
    hp: i8,
    armor: i8,
    mana: i16,
    mana_spent: i16,
    active: [5]u3,
    boss_hp: i8,
    boss_damage: i8,

    pub fn turn(self: *State, spell: usize) void {
        for (0..spells.len) |si| {
            if (self.active[si] == 0) {
                continue;
            }
            self.hp += spells[si].heal;
            self.mana += spells[si].mana;
            self.boss_hp -= spells[si].damage;
            self.active[si] -= 1;
            if (self.active[si] == 0) {
                self.armor -= spells[si].armor;
            }
        }
        self.mana -= spells[spell].cost;
        self.mana_spent += spells[spell].cost;
        if (spells[spell].turns > 0) {
            self.active[spell] = spells[spell].turns;
            self.armor += spells[spell].armor;
        } else {
            self.hp += spells[spell].heal;
            self.mana += spells[spell].mana;
            self.boss_hp -= spells[spell].damage;
        }
        if (self.boss_hp <= 0) {
            return;
        }

        // boss turn
        for (0..spells.len) |si| {
            if (self.active[si] == 0) {
                continue;
            }
            self.hp += spells[si].heal;
            self.mana += spells[si].mana;
            self.boss_hp -= spells[si].damage;
            self.active[si] -= 1;
            if (self.active[si] == 0) {
                self.armor -= spells[si].armor;
            }
        }
        if (self.boss_hp <= 0) {
            return;
        }

        self.hp -= @max(1, self.boss_damage - self.armor);
    }
};

const WORK_SIZE = 131072;

fn parts(inp: []const u8) anyerror![2]usize {
    var i: usize = 12;
    const hp = @as(i8, @intCast(try aoc.chompInt(isize, inp, &i)));
    i += 9;
    const damage = @as(i8, @intCast(try aoc.chompInt(isize, inp, &i)));
    var back: [WORK_SIZE]State = .{undefined} ** WORK_SIZE;
    var todo = aoc.Deque(State).init(back[0..]);
    try todo.push(State{
        .hp = 50,
        .mana = 500,
        .mana_spent = 0,
        .armor = 0,
        .active = [5]u3{ 0, 0, 0, 0, 0 },
        .boss_hp = hp,
        .boss_damage = damage,
    });
    var p1: isize = 10_000_000;
    while (todo.pop()) |cur| {
        for (0..spells.len) |si| {
            if (cur.active[si] > 1) {
                continue; // currently active
            }
            if (cur.mana < spells[si].cost) {
                continue; // too expensive
            }
            if (cur.mana_spent + spells[si].cost > p1) {
                continue; // already spent too much mana
            }
            var new = State{
                .hp = cur.hp,
                .mana = cur.mana,
                .mana_spent = cur.mana_spent,
                .armor = cur.armor,
                .active = [5]u3{ cur.active[0], cur.active[1], cur.active[2], cur.active[3], cur.active[4] },
                .boss_hp = cur.boss_hp,
                .boss_damage = cur.boss_damage,
            };
            new.turn(si);
            if (new.boss_hp <= 0) {
                if (p1 > new.mana_spent) {
                    p1 = new.mana_spent;
                }
                continue;
            }
            if (new.hp <= 0) {
                // lost
                continue;
            }
            try todo.push(new);
        }
    }

    try todo.push(State{
        .hp = 50,
        .mana = 500,
        .mana_spent = 0,
        .armor = 0,
        .active = [5]u3{ 0, 0, 0, 0, 0 },
        .boss_hp = hp,
        .boss_damage = damage,
    });
    var p2: isize = 10_000_000;
    while (todo.pop()) |cur| {
        if (cur.hp <= 1) {
            continue; // hard mode death
        }
        for (0..spells.len) |si| {
            if (cur.active[si] > 1) {
                continue; // currently active
            }
            if (cur.mana < spells[si].cost) {
                continue; // too expensive
            }
            if (cur.mana_spent + spells[si].cost > p2) {
                continue; // already spent too much mana
            }
            var new = State{
                .hp = cur.hp - 1,
                .mana = cur.mana,
                .mana_spent = cur.mana_spent,
                .armor = cur.armor,
                .active = [5]u3{ cur.active[0], cur.active[1], cur.active[2], cur.active[3], cur.active[4] },
                .boss_hp = cur.boss_hp,
                .boss_damage = cur.boss_damage,
            };
            new.turn(si);
            if (new.boss_hp <= 0) {
                if (p2 > new.mana_spent) {
                    p2 = new.mana_spent;
                }
                continue;
            }
            if (new.hp <= 0) {
                // lost
                continue;
            }
            try todo.push(new);
        }
    }

    return [2]usize{ @as(usize, @intCast(p1)), @as(usize, @intCast(p2)) };
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
