const std = @import("std");
const aoc = @import("aoc-lib.zig");

const shop = @embedFile("shop.txt");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var boss: [3]isize = undefined;
    {
        var it = aoc.uintIter(isize, inp);
        boss = [3]isize{ it.next().?, it.next().?, it.next().? };
    }
    var bw = try std.BoundedArray([3]isize, 8).init(0);
    var ba = try std.BoundedArray([3]isize, 8).init(0);
    try ba.append([3]isize{ 0, 0, 0 });
    var br = try std.BoundedArray([3]isize, 8).init(0);
    try br.append([3]isize{ 0, 0, 0 });
    try br.append([3]isize{ 0, 0, 0 });
    {
        var it = aoc.uintIter(isize, shop);
        for (0..5) |_| {
            try bw.append([3]isize{ it.next().?, it.next().?, it.next().? });
        }
        for (0..5) |_| {
            try ba.append([3]isize{ it.next().?, it.next().?, it.next().? });
        }
        for (0..6) |_| {
            _ = it.next();
            const entry = [3]isize{ it.next().?, it.next().?, it.next().? };
            var j: usize = 0;
            while (j < br.len and br.get(j)[0] < entry[0]) : (j += 1) {}
            try br.insert(j, entry);
        }
    }
    const weapons = bw.slice();
    const armor = ba.slice();
    const rings = br.slice();

    var p1: usize = 1_000_000;
    var p2: usize = 0;
    for (weapons) |w| {
        for (armor) |a| {
            for (0..rings.len) |i| {
                for (i + 1..rings.len) |j| {
                    const cost = w[0] + a[0] + rings[i][0] + rings[j][0];
                    if (battle(boss, [3]isize{ 100, w[1] + rings[i][1] + rings[j][1], a[2] + rings[i][2] + rings[j][2] })) {
                        if (cost < p1) {
                            p1 = @intCast(cost);
                        }
                    } else {
                        if (cost > p2) {
                            p2 = @intCast(cost);
                        }
                    }
                }
            }
        }
    }

    return [2]usize{ p1, p2 };
}

fn battle(boss: [3]isize, player: [3]isize) bool {
    const pt = deadTime(player[0], boss[1], player[2]);
    const bt = deadTime(boss[0], player[1], boss[2]);
    return bt <= pt;
}

fn deadTime(hp: isize, damage: isize, armor: isize) usize {
    const fhp: f64 = @floatFromInt(hp);
    const fdamage: f64 = @floatFromInt(@max(1, damage - armor));
    return @as(usize, @intFromFloat(@ceil(fhp / fdamage)));
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
