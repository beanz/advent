const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var i: usize = 0;
    var res: [16]isize = .{0} ** 16;
    var mod: [16]isize = .{0} ** 16;
    var n: usize = 0;
    while (i < inp.len) : (i += 1) {
        i += 12;
        const m = try aoc.chompUint(isize, inp, &i);
        i += 41;
        const p = try aoc.chompUint(isize, inp, &i);
        i += 1;
        res[n] = @mod(m - p - (@as(isize, @intCast(n)) + 1), m);
        mod[n] = m;
        n += 1;
    }
    const p1 = @as(usize, @intCast(aoc.crt(isize, res[0..n], mod[0..n])));
    res[n] = @mod(11 - (@as(isize, @intCast(n)) + 1), 11);
    mod[n] = 11;
    n += 1;
    const p2 = @as(usize, @intCast(aoc.crt(isize, res[0..n], mod[0..n])));
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
