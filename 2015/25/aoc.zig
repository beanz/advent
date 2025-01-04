const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var i: usize = 80;
    const y = try aoc.chompUint(usize, inp, &i);
    i += 9;
    const x = try aoc.chompUint(usize, inp, &i);
    const sy = sum_series(1, y - 2);
    const sx = sum_series(1, x);
    const p = (x * (y - 1)) + sy + sx;
    const p1 = (mod_exp(252533, p - 1, 33554393) * 20151125) % 33554393;
    return [2]usize{ p1, 0 };
}

fn sum_series(s: usize, e: usize) usize {
    return ((1 + e - s) * (s + e)) / 2;
}

fn mod_exp(ia: usize, ib: usize, m: usize) usize {
    var a = ia % m;
    var b = ib;
    var c: usize = 1;
    while (b != 0) {
        if (b & 1 == 1) {
            c = (c * a) % m;
        }
        a = (a * a) % m;
        b >>= 1;
    }
    return c;
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
