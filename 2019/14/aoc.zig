const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const ORE = 1656;
const FUEL = 1116;

fn parts(inp: []const u8) anyerror![2]usize {
    var back: [36864]u32 = .{0} ** 36864;
    var fact = aoc.ListOfLists(u32).init(back[0..], 4096);
    var factn: [4096]usize = .{0} ** 4096;
    {
        var s = try std.BoundedArray([2]u16, 8).init(0);
        var i: usize = 0;
        while (i < inp.len) : (i += 1) {
            while (true) {
                const n = try aoc.chompUint(u16, inp, &i);
                i += 1;
                const id = try aoc.chompIdentifier(u16, inp, &i, 227, 0xfff);
                i += 2;
                try s.append([2]u16{ n, id });
                if (inp[i] == '>') {
                    break;
                }
            }
            i += 2;
            const m = try aoc.chompUint(u16, inp, &i);
            i += 1;
            const pid = try aoc.chompIdentifier(u16, inp, &i, 227, 0xfff);
            factn[pid] = m;
            for (s.slice()) |r| {
                try fact.put(pid, (@as(u32, @intCast(r[0])) << 16) + @as(u32, @intCast(r[1])));
            }
            try s.resize(0);
        }
    }
    const p1 = ore_for(1, &fact, &factn);
    const target = 1_000_000_000_000;
    var upper: usize = 1;
    while (ore_for(upper, &fact, &factn) < target) : (upper *= 2) {}
    var lower = upper >> 1;
    while (true) {
        const mid = lower + (upper - lower) / 2;
        if (mid == lower) {
            break;
        }
        if (ore_for(mid, &fact, &factn) > target) {
            upper = mid;
        } else {
            lower = mid;
        }
    }
    return [2]usize{ p1, lower };
}

fn ore_for(n: usize, fact: *aoc.ListOfLists(u32), factn: *[4096]usize) usize {
    var surplus: [4096]usize = .{0} ** 4096;
    var total: [4096]usize = .{0} ** 4096;
    requirements(FUEL, n, fact, factn, &total, &surplus, ORE);
    return total[ORE];
}

fn requirements(chem: u16, needed: usize, fact: *aoc.ListOfLists(u32), factn: *[4096]usize, total: *[4096]usize, surplus: *[4096]usize, last: u16) void {
    if (chem == last) {
        return;
    }
    var need = needed;
    const avail = surplus[chem];
    if (avail > needed) {
        surplus[chem] -= needed;
        return;
    }
    if (avail > 0) {
        need -= avail;
        surplus[chem] = 0;
    }
    const n = factn[chem];
    const ing = fact.items(chem);
    const required = @divTrunc(need + n - 1, n);
    const leftover = n * required - need;
    surplus[chem] += leftover;
    for (ing) |i| {
        const in = i >> 16;
        const id = @as(u16, @intCast(i & 0xffff));
        total[id] += in * required;
        requirements(id, in * required, fact, factn, total, surplus, last);
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
