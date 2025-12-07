const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var x: usize = 0;
    var p1: usize = 0;

    var b: [256]usize = .{0} ** 256;
    for (0..inp.len) |i| {
        switch (inp[i]) {
            'S' => b[x] += 1,
            '\n' => {
                x = 0;
                continue;
            },
            '^' => {
                if (b[x] > 0) {
                    b[x - 1] += b[x];
                    b[x + 1] += b[x];
                    b[x] = 0;
                    p1 += 1;
                }
            },
            else => {},
        }
        x += 1;
    }
    var p2: usize = 0;
    for (b) |c| {
        p2 += c;
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
