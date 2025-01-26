const std = @import("std");
const aoc = @import("aoc-lib.zig");

fn parts(in: []const u8, days1: usize, days2: usize) [2]usize {
    var f = [_]usize{ 0, 0, 0, 0, 0, 0, 0, 0, 0 };
    for (in) |ch| {
        if (ch < '0') {
            continue;
        }
        f[ch - 48] += 1;
    }
    var z: usize = 0;
    var d: usize = 0;
    while (d < days1) : (d += 1) {
        f[(z + 7) % 9] += f[z];
        z = (z + 1) % 9;
    }
    var p1: usize = 0;
    for (f) |fc| {
        p1 += fc;
    }
    while (d < days2) : (d += 1) {
        f[(z + 7) % 9] += f[z];
        z = (z + 1) % 9;
    }
    var p2: usize = 0;
    for (f) |fc| {
        p2 += fc;
    }
    return [2]usize{ p1, p2 };
}

test "examples" {
    try aoc.assertEq(@as(usize, 5), parts(aoc.test1file, 1, 1)[0]);
    try aoc.assertEq(@as(usize, 6), parts(aoc.test1file, 2, 2)[0]);
    try aoc.assertEq(@as(usize, 7), parts(aoc.test1file, 3, 3)[0]);
    try aoc.assertEq(@as(usize, 9), parts(aoc.test1file, 4, 4)[0]);
    try aoc.assertEq(@as(usize, 10), parts(aoc.test1file, 5, 5)[0]);
    try aoc.assertEq(@as(usize, 11), parts(aoc.test1file, 9, 9)[0]);
    try aoc.assertEq(@as(usize, 26), parts(aoc.test1file, 18, 18)[0]);
    const p = parts(aoc.test1file, 80, 256);
    try aoc.assertEq(@as(usize, 5934), p[0]);
    try aoc.assertEq(@as(usize, 26984457539), p[1]);
    const pi = parts(aoc.inputfile, 80, 256);
    try aoc.assertEq(@as(usize, 365131), pi[0]);
    try aoc.assertEq(@as(usize, 1650309278600), pi[1]);
}

fn day06(inp: []const u8, bench: bool) anyerror!void {
    const p = parts(inp, 80, 256);
    if (!bench) {
        aoc.print("Part 1: {}\nPart 2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day06);
}
