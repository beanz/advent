const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var p1s = [2]i16{ 0, 0 };
    var p2s = [2][2]i16{ .{ 0, 0 }, .{ 0, 0 } };
    var s1 = std.AutoHashMap([2]i16, bool).init(aoc.halloc);
    var s2 = std.AutoHashMap([2]i16, bool).init(aoc.halloc);
    try s1.put(p1s, true);
    try s2.put(p2s[0], true);
    for (inp, 0..) |ch, i| {
        switch (ch) {
            '^' => {
                p1s[1] -= 1;
                p2s[i & 1][1] -= 1;
            },
            'v' => {
                p1s[1] += 1;
                p2s[i & 1][1] += 1;
            },
            '<' => {
                p1s[0] -= 1;
                p2s[i & 1][0] -= 1;
            },
            '>' => {
                p1s[0] += 1;
                p2s[i & 1][0] += 1;
            },
            else => {},
        }
        try s1.put(p1s, true);
        try s2.put(p2s[i & 1], true);
    }
    return [2]usize{ s1.count(), s2.count() };
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
