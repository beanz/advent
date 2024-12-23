const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var p1: usize = 0;
    var p2: usize = 0;
    var i: usize = 0;
    while (i < inp.len) : (i += 2) {
        i += 12;
        const ax = try aoc.chompUint(isize, inp, &i);
        i += 4;
        const ay = try aoc.chompUint(isize, inp, &i);
        i += 13;
        const bx = try aoc.chompUint(isize, inp, &i);
        i += 4;
        const by = try aoc.chompUint(isize, inp, &i);
        i += 10;
        const px = try aoc.chompUint(isize, inp, &i);
        i += 4;
        const py = try aoc.chompUint(isize, inp, &i);
        p1 += cost(ax, ay, bx, by, px, py, 0);
        p2 += cost(ax, ay, bx, by, px, py, 10000000000000);
    }
    return [2]usize{ p1, p2 };
}
fn cost(ax: isize, ay: isize, bx: isize, by: isize, ppx: isize, ppy: isize, add: isize) usize {
    const px = ppx + add;
    const py = ppy + add;
    const d = ax * by - ay * bx;
    if (d == 0) {
        return 0;
    }
    const x = px * by - py * bx;
    const m = @divFloor(x, d);
    if (m * d != x) {
        return 0;
    }
    const xx = py - ay * m;
    const mm = @divFloor(xx, by);
    if (mm * by != xx) {
        return 0;
    }
    const res: usize = @intCast(3 * m + mm);
    return res;
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
