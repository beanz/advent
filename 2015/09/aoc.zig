const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var ids: [256]u8 = .{0} ** 256;
    var g: [256]usize = .{0} ** 256;
    var i: usize = 0;
    var n: u8 = 1;
    while (i < inp.len) {
        var a: u8 = inp[i];
        i += 1;
        while (inp[i] != ' ') {
            a = (a *% 173) ^ inp[i];
            i += 1;
        }
        if (ids[a] == 0) {
            ids[a] = n;
            n += 1;
        }
        a = ids[a];
        i += 4;
        var b: u8 = inp[i];
        i += 1;
        while (inp[i] != ' ') {
            b = (b *% 173) ^ inp[i];
            i += 1;
        }
        if (ids[b] == 0) {
            ids[b] = n;
            n += 1;
        }
        b = ids[b];
        i += 3;
        const c = try aoc.chompUint(usize, inp, &i);
        i += 1;
        g[a * 8 + b] = c;
        g[b * 8 + a] = c;
    }
    var back: [65536][3]usize = .{[3]usize{ 0, 0, 0 }} ** 65536;
    var todo: aoc.Deque([3]usize) = aoc.Deque([3]usize).init(&back);
    {
        var bit: usize = 1;
        for (1..n) |s| {
            try todo.push([3]usize{ s, bit, 0 });
            bit <<= 1;
        }
    }
    const res = solve(&g, 0, 0, n);
    return res;
}

fn solve(g: *[256]usize, pos: usize, seen: usize, n: usize) [2]usize {
    var min: usize = 1_000_000_000;
    var max: usize = 0;
    var bit: usize = 1;
    var done = true;
    for (1..n) |np| {
        const base_cost = g[pos * 8 + np];
        if (seen & bit == 0) {
            done = false;
            const sub = solve(g, np, seen | bit, n);
            const sub_min = base_cost + sub[0];
            const sub_max = base_cost + sub[1];
            if (sub_max > max) {
                max = sub_max;
            }
            if (sub_min < min) {
                min = sub_min;
            }
        }
        bit <<= 1;
    }
    if (done) {
        return [2]usize{ 0, 0 };
    }
    return [2]usize{ min, max };
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
