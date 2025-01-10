const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var i: usize = 0;
    const n = try aoc.chompUint(usize, inp, &i);
    var cur: usize = 0;
    var v: [2048]usize = .{0} ** 2048;
    for (1..2017 + 1) |t| {
        for (0..n) |_| {
            cur = v[cur];
        }
        const tmp = v[cur];
        v[cur] = t;
        v[t] = tmp;
        cur = t;
    }
    const p1 = v[2017];
    i = 0;
    var p2: usize = 0;
    for (1..50000000 + 1) |t| {
        i = (i + n) % t;
        if (i == 0) {
            p2 = t;
        }
        i += 1;
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
