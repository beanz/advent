const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    const n = @as(usize, inp[6] & 0xf) * 10 + @as(usize, inp[7] & 0xf);
    const p1 = (n - 2) * (n - 2);
    var p2: usize = 0;
    var b = n * 100 + 100000;
    const c = b + 17000;
    while (b <= c) : (b += 17) {
        if (b & 1 == 0) {
            p2 += 1;
            continue;
        }
        var d: usize = 3;
        while (d * d < b) : (d += 2) {
            if (b % d == 0) {
                p2 += 1;
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
