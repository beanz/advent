const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var b = try std.BoundedArray([3]usize, 64).init(0);
    var it = aoc.uintIter(usize, inp);
    while (it.next()) |depth| {
        const range = it.next().?;
        try b.append([3]usize{ depth, range, (range - 1) * 2 });
    }
    const f = b.slice();
    var p1: usize = 0;
    for (f) |l| {
        if (l[0] % l[2] == 0) {
            p1 += l[0] * l[1];
        }
    }
    var p2: usize = 0;
    LOOP: while (true) : (p2 += 1) {
        for (f) |l| {
            if ((l[0] + p2) % l[2] == 0) {
                continue :LOOP;
            }
        }
        break;
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
