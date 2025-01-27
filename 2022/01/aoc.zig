const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var m0: usize = 0;
    var m1: usize = 0;
    var m2: usize = 0;
    var eol = false;
    var n: usize = 0;
    var s: usize = 0;
    for (inp) |ch| {
        switch (ch) {
            '\n' => if (eol) {
                if (s > m0) {
                    std.mem.swap(usize, &s, &m0);
                }
                if (s > m1) {
                    std.mem.swap(usize, &s, &m1);
                }
                if (s > m2) {
                    std.mem.swap(usize, &s, &m2);
                }
                s = 0;
                eol = false;
            } else {
                s += n;
                n = 0;
                eol = true;
            },
            else => {
                eol = false;
                n = 10 * n + @as(usize, @intCast(ch & 0xf));
            },
        }
    }
    if (eol) {
        if (s > m0) {
            std.mem.swap(usize, &s, &m0);
        }
        if (s > m1) {
            std.mem.swap(usize, &s, &m1);
        }
        if (s > m2) {
            std.mem.swap(usize, &s, &m2);
        }
    }
    return [2]usize{ m0, m0 + m1 + m2 };
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
