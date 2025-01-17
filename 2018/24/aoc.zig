const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Int = u32;

const Attack = enum(u5) {
    Bludgeon = 1,
    Cold = 2,
    Fire = 4,
    Radiate = 8,
    Slash = 16,
};

const Side = enum {
    Immune,
    Infect,
};

const Group = struct {
    units_init: Int,
    units: Int,
    hp: Int,
    weak: u5,
    immune: u5,
    damage: Int,
    attack: Attack,
    initiative: Int,
    side: Side,

    fn reset(self: *Group) void {
        self.units = self.units_init;
    }
    fn alive(self: Group) bool {
        return self.units > 0;
    }
    fn power(self: Group, boost: Int) Int {
        if (self.side == Side.Immune) {
            return self.units * (boost + self.damage);
        }
        return self.units * self.damage;
    }
};

fn parts(inp: []const u8) anyerror![2]usize {
    var s = try std.BoundedArray(Group, 20).init(0);
    var i: usize = 15;
    while (i < inp.len) {
        const g = try read_group(Side.Immune, inp, &i);
        try s.append(g);
        if (inp[i] == '\n') {
            break;
        }
    }
    i += 12;
    while (i < inp.len) {
        const g = try read_group(Side.Infect, inp, &i);
        try s.append(g);
    }
    const groups = s.slice();
    const p1 = try play(groups, 0);

    var upper: Int = 16000;
    while (true) {
        for (0..groups.len) |j| {
            groups[j].reset();
        }
        const c = try play(groups, upper);
        if (c[0] != 0) {
            break;
        }
        upper <<= 1;
    }
    var lower: Int = 0;
    while (upper - lower > 10) {
        const cur = (upper + lower) / 2;
        for (0..groups.len) |j| {
            groups[j].reset();
        }
        const c = try play(groups, cur);
        if (c[0] != 0 and c[1] != 0) {
            upper += 3;
        } else if (c[0] == 0) {
            lower = cur;
        } else {
            upper = cur;
        }
        //if (c[0] != 0) {
        //    break;
        //}
    }

    var boost = lower;
    var p2: usize = 0;
    while (boost <= upper) : (boost += 1) {
        for (0..groups.len) |j| {
            groups[j].reset();
        }
        const c = try play(groups, boost);
        if (c[0] != 0 and c[1] == 0) {
            p2 = c[0];
            break;
        }
    }

    return [2]usize{ p1[0] + p1[1], p2 };
}

fn play(groups: []Group, boost: Int) anyerror![2]Int {
    var immuneCount: Int = undefined;
    var infectCount: Int = undefined;
    while (true) {
        var order = try std.BoundedArray([2]usize, 20).init(0);
        try target_order(&order, groups, boost);
        const progressing = attacks(groups, order.slice(), boost);
        immuneCount = count(groups, Side.Immune);
        infectCount = count(groups, Side.Infect);
        if (!progressing or infectCount == 0 or immuneCount == 0) {
            break;
        }
    }
    return [2]Int{ immuneCount, infectCount };
}

fn attacks(groups: []Group, order: [][2]usize, boost: Int) bool {
    var damageDone = false;
    for (order) |o| {
        const attacker = o[0];
        const target = o[1];
        if (!groups[attacker].alive() or !groups[target].alive()) {
            continue;
        }
        const attack = attack_damage(groups, attacker, target, boost);
        const units = @min(attack / groups[target].hp, groups[target].units);
        if (units > 0) {
            damageDone = true;
        }
        groups[target].units -= units;
    }
    return damageDone;
}

fn attack_damage(groups: []const Group, attacker: usize, target: usize, boost: Int) Int {
    const kind = @intFromEnum(groups[attacker].attack);
    const mul: Int = if (groups[target].weak & kind != 0) 2 else if (groups[target].immune & kind != 0) 0 else 1;
    return groups[attacker].power(boost) * mul;
}

fn target_order(order: *std.BoundedArray([2]usize, 20), groups: []const Group, boost: Int) anyerror!void {
    var s = try std.BoundedArray(usize, 20).init(0);
    for (groups, 0..) |g, i| {
        if (g.alive()) {
            try s.append(i);
        }
    }
    var attackOrder = s.slice();
    std.mem.sort(usize, attackOrder[0..], SortCtx{ .groups = groups, .boost = boost }, attackCmp);

    var selected: usize = 0;
    for (attackOrder) |attacker| {
        var best_target: usize = 99;
        var best_damage: Int = 0;
        for (attackOrder) |target| {
            if (groups[target].side == groups[attacker].side or !groups[target].alive()) {
                continue;
            }
            if (selected & (@as(usize, 1) << @as(u5, @intCast(target))) != 0) {
                continue;
            }
            const damage = attack_damage(groups, attacker, target, boost);
            if (damage > best_damage) {
                best_damage = damage;
                best_target = target;
            }
        }
        if (best_target != 99) {
            try order.append([2]usize{ attacker, best_target });
            selected |= @as(usize, 1) << @as(u5, @intCast(best_target));
        }
    }
    std.mem.sort([2]usize, order.slice(), groups, initiativeCmp);
}

fn initiativeCmp(groups: []const Group, a: [2]usize, b: [2]usize) bool {
    return groups[a[0]].initiative > groups[b[0]].initiative;
}

const SortCtx = struct {
    groups: []const Group,
    boost: Int,
};

fn attackCmp(ctx: SortCtx, a: usize, b: usize) bool {
    const pa = ctx.groups[a].power(ctx.boost);
    const pb = ctx.groups[b].power(ctx.boost);
    if (pa == pb) {
        return ctx.groups[a].initiative > ctx.groups[b].initiative;
    }
    return pa > pb;
}

fn count(groups: []const Group, side: Side) Int {
    var c: Int = 0;
    for (groups) |g| {
        if (g.side == side) {
            c += g.units;
        }
    }
    return c;
}

fn read_group(side: Side, inp: []const u8, i: *usize) anyerror!Group {
    const units = try aoc.chompUint(Int, inp, i);
    i.* += 17;
    const hp = try aoc.chompUint(Int, inp, i);
    var weak: u5 = 0;
    var immune: u5 = 0;
    i.* += 12;
    if (inp[i.*] == '(') {
        i.* += 1;
        switch (inp[i.*]) {
            'w' => {
                i.* += 8;
                weak = read_attacks(inp, i);
                if (inp[i.*] == ';' and inp[i.* + 2] == 'i') {
                    i.* += 12;
                    immune = read_attacks(inp, i);
                }
            },
            'i' => {
                i.* += 10;
                immune = read_attacks(inp, i);
                if (inp[i.*] == ';' and inp[i.* + 2] == 'w') {
                    i.* += 10;
                    weak = read_attacks(inp, i);
                }
            },
            else => unreachable,
        }
        i.* += 2;
    }
    i.* += 25;
    const damage = try aoc.chompUint(Int, inp, i);
    i.* += 1;
    const attack = read_attack(inp, i);
    i.* += 22;
    const initiative = try aoc.chompUint(Int, inp, i);
    i.* += 1;
    return Group{
        .units = units,
        .units_init = units,
        .hp = hp,
        .weak = weak,
        .immune = immune,
        .damage = damage,
        .attack = attack,
        .initiative = initiative,
        .side = side,
    };
}

fn read_attacks(inp: []const u8, i: *usize) u5 {
    var attack: u5 = 0;
    while (i.* < inp.len) {
        switch (inp[i.*]) {
            'b' => {
                i.* += 11;
                attack |= @intFromEnum(Attack.Bludgeon);
            },
            'c' => {
                i.* += 4;
                attack |= @intFromEnum(Attack.Cold);
            },
            'f' => {
                i.* += 4;
                attack |= @intFromEnum(Attack.Fire);
            },
            'r' => {
                i.* += 9;
                attack |= @intFromEnum(Attack.Radiate);
            },
            's' => {
                i.* += 8;
                attack |= @intFromEnum(Attack.Slash);
            },
            ',' => {
                i.* += 2;
            },
            ')', ';' => {
                break;
            },
            else => unreachable,
        }
    }
    return attack;
}

fn read_attack(inp: []const u8, i: *usize) Attack {
    switch (inp[i.*]) {
        'b' => {
            i.* += 11;
            return Attack.Bludgeon;
        },
        'c' => {
            i.* += 4;
            return Attack.Cold;
        },
        'f' => {
            i.* += 4;
            return Attack.Fire;
        },
        'r' => {
            i.* += 9;
            return Attack.Radiate;
        },
        's' => {
            i.* += 8;
            return Attack.Slash;
        },
        else => unreachable,
    }
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
