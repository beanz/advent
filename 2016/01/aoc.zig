const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var x: i32 = 0;
    var y: i32 = 0;
    var dx: i32 = 0;
    var dy: i32 = -1;
    var i: usize = 0;
    var p2: ?usize = null;
    var seen: [1048576]bool = .{false} ** 1048576;
    var k = (@as(usize, @abs(x + 512)) << 10) + @as(usize, @abs(y + 512));
    seen[k] = true;
    while (i < inp.len) {
        if (inp[i] == 'R') {
            const t = dx;
            dx = -dy;
            dy = t;
        } else {
            const t = dx;
            dx = dy;
            dy = -t;
        }
        i += 1;
        const n = try aoc.chompUint(usize, inp, &i);
        for (0..n) |_| {
            x += dx;
            y += dy;
            k = (@as(usize, @abs(x + 512)) << 9) + @as(usize, @abs(y + 512));
            if (p2 == null and seen[k]) {
                p2 = @abs(x) + @abs(y);
            }
            seen[k] = true;
        }
        i += 2;
    }
    const p1 = @abs(x) + @abs(y);
    return [2]usize{ p1, p2.? };
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
