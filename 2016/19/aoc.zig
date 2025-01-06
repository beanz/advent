const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var i: usize = 0;
    const n = try aoc.chompUint(usize, inp, &i);

    // https://oeis.org/A006257
    var msb: usize = 1;
    while (msb <= n) : (msb <<= 1) {}
    msb >>= 1;
    const p1 = if (n == msb) 1 else 1 + (n - msb) * 2;

    // https://oeis.org/A334473
    var mst: usize = 1;
    while (mst <= n) : (mst *= 3) {}
    mst /= 3;
    const p2 = if (n == mst) n else if (n < 2 * mst) n % mst else mst + 2 * (n % mst);
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
