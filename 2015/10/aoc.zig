const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var cur = try aoc.halloc.alloc(u8, 7000000);
    var l = inp.len - 1;
    var nl: usize = 0;
    std.mem.copyForwards(u8, cur[0..l], inp[0..l]);
    var next = try aoc.halloc.alloc(u8, 7000000);
    var p1: usize = 0;
    for (0..50) |d| {
        var n: usize = 1;
        var c = cur[0];
        for (1..l) |i| {
            if (cur[i] == c) {
                n += 1;
            } else {
                var m: usize = 10;
                while (m < n) : (m *= 10) {}
                while (m > 1) {
                    m /= 10;
                    next[nl] = '0' + @as(u8, @truncate((n / m) % 10));
                    nl += 1;
                }
                next[nl] = c;
                nl += 1;
                c = cur[i];
                n = 1;
            }
        }
        var m: usize = 10;
        while (m < n) : (m *= 10) {}
        while (m > 1) {
            m /= 10;
            next[nl] = '0' + @as(u8, @truncate((n / m) % 10));
            nl += 1;
        }
        next[nl] = c;
        nl += 1;
        const tmp = next;
        next = cur;
        cur = tmp;
        l = nl;
        nl = 0;
        if (d == 39) {
            p1 = l;
        }
    }
    return [2]usize{ p1, l };
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
