const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var i: usize = 0;
    var a1: usize = 0;
    var a2: usize = 0;
    var p: isize = 50;
    while (i < inp.len) : (i += 1) {
        var dir: isize = 1;
        if (inp[i] == 'L') {
            dir = -1;
        }
        i += 1;
        var n = try aoc.chompUint(usize, inp, &i);
        a2 += @divFloor(n, 100);
        n = @rem(n, 100);
        if (p == 0 and dir == -1) {
            p = 100;
        }
        p += dir * @as(isize, @intCast(n));
        if (p <= 0) {
            a2 += 1;
            if (p < 0) {
                p += 100;
            }
        } else if (p >= 100) {
            a2 += 1;
            p -= 100;
        }
        if (p == 0) {
            a1 += 1;
        }
    }

    return [2]usize{ a1, a2 };
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
