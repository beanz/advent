const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var row: u128 = 0;
    var mask: u128 = 0;
    var i: usize = 0;
    while (i < inp.len - 1) : (i += 1) {
        row = (row << 1) | @intFromBool(inp[i] == '^');
        mask = (mask << 1) | 1;
    }
    // new trap if left XOR right
    var safe: usize = 0;
    for (0..40) |_| {
        safe += @popCount(mask ^ row);
        row = ((row << 1) ^ (row >> 1)) & mask;
    }
    const p1 = safe;
    for (40..400000) |_| {
        safe += @popCount(mask ^ row);
        row = ((row << 1) ^ (row >> 1)) & mask;
    }
    return [2]usize{ p1, safe };
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
