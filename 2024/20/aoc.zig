const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var i: usize = 0;
    while (inp[i] != '\n') : (i += 1) {}
    const w = i + 1;
    const limit: isize = if (w < 20) 20 else 100;
    var start: usize = 0;
    var end: usize = 0;
    while (i < inp.len) : (i += 1) {
        switch (inp[i]) {
            'E' => {
                end = i;
                if (start != 0) {
                    break;
                }
            },
            'S' => {
                start = i;
                if (end != 0) {
                    break;
                }
            },
            else => {},
        }
    }
    const Rec = struct { x: i32, y: i32 };
    var p = try std.BoundedArray(Rec, 10240).init(0);
    var pos = start;
    var prev: usize = 0;
    while (true) {
        try p.append(Rec{ .x = @as(i32, @intCast(pos % w)), .y = @as(i32, @intCast(pos / w)) });
        if (pos == end) {
            break;
        }
        const tmp = pos;
        if (pos - w != prev and inp[pos - w] != '#') {
            pos -= w;
        } else if (pos + 1 != prev and inp[pos + 1] != '#') {
            pos += 1;
        } else if (pos + w != prev and inp[pos + w] != '#') {
            pos += w;
        } else if (pos - 1 != prev and inp[pos - 1] != '#') {
            pos -= 1;
        }
        prev = tmp;
    }
    const path = p.slice();
    var p1: usize = 0;
    var p2: usize = 0;
    for (0..path.len) |j| {
        const a = path[j];
        for (j + 1..path.len) |k| {
            const b = path[k];
            const md: isize = @intCast(@abs(a.x - b.x) + @abs(a.y - b.y));
            const cheat = @as(isize, @intCast(k - j)) - md;
            if (cheat >= limit) {
                if (md == 2) {
                    p1 += 1;
                }
                if (md <= 20) {
                    p2 += 1;
                }
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
