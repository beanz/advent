const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var p1a: isize = 0;
    var p1p: usize = 0;
    var p2a: isize = 0;
    var p2p: usize = 0;
    var x1: isize = 0;
    var y1: isize = 0;
    var x2: isize = 0;
    var y2: isize = 0;
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        var o = oxoy(inp[i]);
        i += 2;
        var n: isize = @intCast(inp[i] - '0');
        i += 1;
        if (inp[i] != ' ') {
            var d: isize = @intCast(inp[i] - '0');
            n = 10 * n + d;
            i += 1;
        }
        i += 3;
        var nx: isize = x1 + o.x * n;
        var ny: isize = y1 + o.y * n;
        p1a += (x1 - nx) * (y1 + ny);
        p1p += @intCast(n);
        x1 = nx;
        y1 = ny;
        o = oxoy(inp[i + 5]);
        n = try std.fmt.parseUnsigned(isize, inp[i .. i + 5], 16);
        nx = x2 + o.x * n;
        ny = y2 + o.y * n;
        p2a += (x2 - nx) * (y2 + ny);
        p2p += @intCast(n);
        x2 = nx;
        y2 = ny;
        i += 7;
    }
    return [2]usize{ (std.math.absCast(p1a) + p1p + 2) / 2, (std.math.absCast(p2a) + p2p + 2) / 2 };
}

fn oxoy(ch: u8) struct { x: isize, y: isize } {
    switch (ch) {
        'R', '0' => return .{ .x = 1, .y = 0 },
        'D', '1' => return .{ .x = 0, .y = 1 },
        'L', '2' => return .{ .x = -1, .y = 0 },
        else => return .{ .x = 0, .y = -1 },
    }
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    var p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
