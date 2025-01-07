const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var it = aoc.uintIter(u32, inp);
    var n: [1600][4]u32 = .{[4]u32{ 0, 0, 0, 0 }} ** 1600;
    var w: u32 = 0;
    var h: u32 = 0;
    while (it.next()) |x| {
        const y = it.next().?;
        const s = it.next().?;
        const u = it.next().?;
        const a = it.next().?;
        const p = it.next().?;
        n[40 * y + x] = [4]u32{ s, u, a, p };
        if (x > w) {
            w = x;
        }
        if (y > h) {
            h = y;
        }
    }
    w += 1;
    h += 1;
    var p1: usize = 0;
    for (0..n.len) |i| {
        const n1 = n[i];
        for (i + 1..n.len) |j| {
            const n2 = n[j];
            if ((n1[1] != 0 and n1[1] <= n2[2]) or (n2[1] != 0 and n2[1] <= n1[2])) {
                p1 += 1;
            }
        }
    }

    var empty: ?[2]usize = null;
    var full: usize = 0;
    for (0..h) |y| {
        for (0..w) |x| {
            if (x == 0 and y == 0) {
                continue;
            }
            if (x == w - 1 and y == 0) {
                continue;
            }
            const used = n[x + y * 40][1];
            if (used == 0) {
                empty = [2]usize{ x, y };
                continue;
            }
            if (used > 150) {
                full += 1;
                continue;
            }
        }
        if (empty != null) {
            break;
        }
    }
    const p2 = 1 + full - (w - empty.?[0]) + full + empty.?[1] + (w - 2) * 5;

    return [2]usize{ p1, p2 };
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
