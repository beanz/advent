const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var i: usize = 0;
    const n = try aoc.chompUint(usize, inp, &i);
    i = 210; // 210 has lots of different prime factors
    var p1: usize = 0;
    {
        while (true) : (i += 210) {
            var s: usize = i * 10;
            for (1..i) |j| {
                if (i % j == 0) {
                    s += j * 10;
                }
            }
            if (s >= n) {
                p1 = i;
                break;
            }
        }
    }
    i = 210; // 210 has lots of different prime factors
    var p2: usize = 0;
    {
        while (true) : (i += 210) {
            var s: usize = i * 11;
            for (i / 50..i) |j| {
                if (i % j == 0) {
                    s += j * 11;
                }
            }
            if (s >= n) {
                p2 = i;
                break;
            }
        }
    }
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
