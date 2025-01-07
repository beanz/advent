const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    const l = inp.len - 1;
    const hl = l / 2;
    var p1: usize = 0;
    var p2: usize = 0;
    for (0..l) |i| {
        p1 += (inp[i] - '0') * @intFromBool(inp[i] == inp[(i + 1) % l]);
        p2 += (inp[i] - '0') * @intFromBool(inp[i] == inp[(i + hl) % l]);
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
