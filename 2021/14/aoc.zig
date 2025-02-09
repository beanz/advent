const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var init: [256]usize = .{0} ** 256;
    var rules: [256]u8 = .{0} ** 256;
    var last: u4 = undefined;
    {
        var i: usize = 0;
        var letters: [26]?u4 = .{null} ** 26;
        var l: u4 = 0;
        while (i + 1 < inp.len) : (i += 1) {
            if (inp[i + 1] == '\n') {
                break;
            }
            const ai = al: {
                const n = inp[i] & 0x1f;
                if (letters[n] == null) {
                    letters[n] = l;
                    l += 1;
                }
                const ai = letters[n].?;
                break :al ai;
            };
            const bi = bl: {
                const n = inp[i + 1] & 0x1f;
                if (letters[n] == null) {
                    letters[n] = l;
                    l += 1;
                }
                const bi = letters[n].?;
                break :bl bi;
            };
            init[(@as(u8, @intCast(ai)) << 4) + bi] += 1;
        }
        last = letters[inp[i] & 0x1f].?;
        i += 3;
        while (i < inp.len) : (i += 8) {
            const ai = al: {
                const n = inp[i] & 0x1f;
                if (letters[n] == null) {
                    letters[n] = l;
                    l += 1;
                }
                const ai = letters[n].?;
                break :al ai;
            };
            const bi = bl: {
                const n = inp[i + 1] & 0x1f;
                if (letters[n] == null) {
                    letters[n] = l;
                    l += 1;
                }
                const bi = letters[n].?;
                break :bl bi;
            };
            const ci = cl: {
                const n = inp[i + 6] & 0x1f;
                if (letters[n] == null) {
                    letters[n] = l;
                    l += 1;
                }
                const ci = letters[n].?;
                break :cl ci;
            };
            rules[(@as(u8, @intCast(ai)) << 4) + bi] = ci;
        }
    }
    var cur = init;
    var next: [256]usize = undefined;
    for (0..10) |_| {
        @memset(next[0..], 0);
        for (0..256) |i| {
            const n = rules[i];
            next[(i & 0xf0) + n] += cur[i];
            next[(n << 4) + (i & 0xf)] += cur[i];
        }
        std.mem.swap([256]usize, &cur, &next);
    }
    var p1c: [16]usize = .{0} ** 16;
    p1c[last] += 1;
    for (0..256) |i| {
        p1c[i >> 4] += cur[i];
    }
    var p1min: usize = std.math.maxInt(usize);
    var p1max: usize = std.math.minInt(usize);
    for (p1c) |c| {
        if (c > p1max) {
            p1max = c;
        }
        if (c > 0 and c < p1min) {
            p1min = c;
        }
    }
    for (10..40) |_| {
        @memset(next[0..], 0);
        for (0..256) |i| {
            const n = rules[i];
            next[(i & 0xf0) + n] += cur[i];
            next[(n << 4) + (i & 0xf)] += cur[i];
        }
        std.mem.swap([256]usize, &cur, &next);
    }
    var p2c: [16]usize = .{0} ** 16;
    p2c[last] += 1;
    for (0..256) |i| {
        p2c[i >> 4] += cur[i];
    }
    var p2min: usize = std.math.maxInt(usize);
    var p2max: usize = std.math.minInt(usize);
    for (p2c) |c| {
        if (c > p2max) {
            p2max = c;
        }
        if (c > 0 and c < p2min) {
            p2min = c;
        }
    }
    return [2]usize{ p1max - p1min, p2max - p2min };
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
