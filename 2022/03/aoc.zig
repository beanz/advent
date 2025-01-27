const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var p1: usize = 0;
    var p2: usize = 0;
    var j: usize = 0;
    var i: usize = 0;
    var s2: usize = std.math.maxInt(usize);
    var k: usize = 0;
    while (i < inp.len) : (i += 1) {
        if (inp[i] == '\n') {
            const l = i - j;
            const l1 = @divExact(l, 2);
            const s1 = set(inp[j .. j + l1]) & set(inp[j + l1 .. i]);
            p1 += @ctz(s1);
            s2 &= set(inp[j..i]);
            k += 1;
            if (k == 3) {
                p2 += @ctz(s2);
                s2 = std.math.maxInt(usize);
                k = 0;
            }
            j = i + 1;
        }
    }
    return [2]usize{ p1, p2 };
}

inline fn set(p: []const u8) usize {
    var s: usize = 0;
    for (p) |ch| {
        const n: u6 = @intCast(if (ch < 'a') 26 + (ch & 0x1f) else ch & 0x1f);
        s |= @as(usize, 1) << n;
    }
    return s;
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
