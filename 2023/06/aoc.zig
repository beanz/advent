const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "examples" {
    try aoc.TestCases(u64, parts);
}

fn parts(inp: []const u8) anyerror![2]u64 {
    var t: u64 = 0;
    var ts = try std.BoundedArray(u64, 8).init(0);
    var i: usize = 0;
    var n: u64 = 0;
    var num = false;
    while (inp[i] != '\n') : (i += 1) {
        switch (inp[i]) {
            '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' => {
                num = true;
                const d = @as(u64, inp[i] - '0');
                n = n * 10 + d;
                t = t * 10 + d;
            },
            else => {
                if (num) {
                    try ts.append(n);
                    num = false;
                    n = 0;
                }
            },
        }
    }
    if (num) {
        try ts.append(n);
        num = false;
        n = 0;
    }
    i += 1;
    var r: u64 = 0;
    var rs = try std.BoundedArray(u64, 8).init(0);
    while (inp[i] != '\n') : (i += 1) {
        switch (inp[i]) {
            '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' => {
                num = true;
                const d = @as(u64, inp[i] - '0');
                n = n * 10 + d;
                r = r * 10 + d;
            },
            else => {
                if (num) {
                    try rs.append(n);
                    num = false;
                    n = 0;
                }
            },
        }
    }
    if (num) {
        try rs.append(n);
    }

    var p1: u64 = 1;
    for (0..ts.len) |j| {
        const c = race(ts.get(j), rs.get(j));
        if (c > 0) {
            p1 *= c;
        }
    }
    return [2]u64{ p1, race(t, r) };
}

fn race(t: u64, r: u64) u64 {
    const ft: f64 = @floatFromInt(t);
    const fr: f64 = @floatFromInt(r);
    const d = @sqrt(ft * ft - 4.0 * (fr + 1.0));
    const l: u64 = @intFromFloat(@ceil((ft - d) / 2));
    const h: u64 = @intFromFloat(@floor((ft + d) / 2));
    return h - l + 1;
}

fn day04(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day04);
}
