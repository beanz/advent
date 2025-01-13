const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    const s = inp[0 .. inp.len - 1];
    var buf: [65536]u8 = .{0} ** 65536;
    const p1 = react(s, &buf, 'A' - 1, s.len);
    var p2 = s.len;
    for ('A'..'Z') |skip| {
        const l = react(s, &buf, @as(u8, @intCast(skip)), p2);
        if (p2 > l) {
            p2 = l;
        }
    }
    return [2]usize{ p1, p2 };
}

fn react(s: []const u8, buf: []u8, skip: u8, ml: usize) usize {
    var l: usize = 0;
    var i: usize = 0;
    while (i < s.len) {
        if (s[i] == skip or s[i] == skip + 32) {
            i += 1;
            continue;
        }
        if (l > 0 and (s[i] == buf[l - 1] + 32 or s[i] == buf[l - 1] - 32)) {
            l -= 1;
        } else {
            buf[l] = s[i];
            l += 1;
            if (l > ml) {
                return ml;
            }
        }
        i += 1;
    }
    return l;
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
