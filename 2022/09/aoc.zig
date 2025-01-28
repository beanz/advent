const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var v1: [1048576]bool = .{false} ** 1048576;
    var v2: [1048576]bool = .{false} ** 1048576;
    var t: [10][2]i32 = .{[2]i32{ 512, 512 }} ** 10;
    var i: usize = 0;
    var p1: usize = 0;
    var p2: usize = 0;
    while (i < inp.len) : (i += 1) {
        const ch = inp[i];
        i += 2;
        const n = try aoc.chompUint(usize, inp, &i);
        const inc = switch (ch) {
            'L' => [2]i32{ -1, 0 },
            'R' => [2]i32{ 1, 0 },
            'U' => [2]i32{ 0, -1 },
            'D' => [2]i32{ 0, 1 },
            else => unreachable,
        };
        for (0..n) |_| {
            t[0][0] += inc[0];
            t[0][1] += inc[1];
            TAIL: for (1..t.len) |j| {
                const dx = t[j - 1][0] - t[j][0];
                const dy = t[j - 1][1] - t[j][1];
                if (-1 <= dx and dx <= 1 and -1 <= dy and dy <= 1) {
                    break :TAIL;
                }
                switch (std.math.order(0, dx)) {
                    .gt => t[j][0] -= 1,
                    .lt => t[j][0] += 1,
                    .eq => {},
                }
                switch (std.math.order(0, dy)) {
                    .gt => t[j][1] -= 1,
                    .lt => t[j][1] += 1,
                    .eq => {},
                }
            }
            const k1: usize = @intCast(t[1][0] + (t[1][1] << 10));
            if (!v1[k1]) {
                p1 += 1;
                v1[k1] = true;
            }
            const k2: usize = @intCast(t[9][0] + (t[9][1] << 10));
            if (!v2[k2]) {
                p2 += 1;
                v2[k2] = true;
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
