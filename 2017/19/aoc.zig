const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCasesRes(Res, parts);
}

const Res = struct {
    p1: [10]u8,
    p2: usize,
};

fn parts(inp: []const u8) anyerror!Res {
    var w: usize = 0;
    var sx: isize = 0;
    while (true) : (w += 1) {
        switch (inp[w]) {
            '\n' => break,
            '|' => sx = @as(isize, @intCast(w)),
            else => {},
        }
    }
    w += 1;
    const wi = @as(isize, @intCast(w));
    var dx: isize = 0;
    var dy: isize = 1;
    var x: isize = sx;
    var y: isize = 0;
    var p2: usize = 1;
    var p1r: [10]u8 = .{32} ** 10;
    var p1i: usize = 0;
    while (true) : (p2 += 1) {
        const ch = inp[@as(usize, @intCast(x + y * wi))];
        if ('A' <= ch and ch <= 'Z') {
            p1r[p1i] = ch;
            p1i += 1;
        }
        {
            const nx = x + dx;
            const ny = y + dy;
            if (inp[@as(usize, @intCast(nx + ny * wi))] != ' ') {
                x = nx;
                y = ny;
                continue;
            }
        }
        {
            const ndx = -dy;
            const ndy = dx;
            const nx = x + ndx;
            const ny = y + ndy;
            if (inp[@as(usize, @intCast(nx + ny * wi))] != ' ') {
                x = nx;
                y = ny;
                dx = ndx;
                dy = ndy;
                continue;
            }
        }
        {
            const ndx = dy;
            const ndy = -dx;
            const nx = x + ndx;
            const ny = y + ndy;
            if (inp[@as(usize, @intCast(nx + ny * wi))] != ' ') {
                x = nx;
                y = ny;
                dx = ndx;
                dy = ndy;
                continue;
            }
        }
        break;
    }
    return Res{ .p1 = p1r, .p2 = p2 };
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {s}\nPart2: {}\n", .{ p.p1, p.p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
