const std = @import("std");
const aoc = @import("aoc-lib.zig");
const Md5 = std.crypto.hash.Md5;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const CHR = "0123456789abcdef";

fn parts(inp: []const u8) anyerror![2]usize {
    var b: [40]u8 = .{0} ** 40;
    var ring: [1001][16]u8 = .{.{0} ** 16} ** 1001;
    var p1: usize = 0;
    {
        std.mem.copyForwards(u8, &b, inp);
        var numStr = try aoc.NumStr.init(aoc.halloc, &b, inp.len - 1);
        for (0..1001) |i| {
            Md5.hash(numStr.bytes(), &ring[i], .{});
            numStr.inc();
        }
        var ringIndex: usize = 0;
        var n: usize = 1;
        loop: while (true) {
            const ti = ringIndex;
            const ri = ti % 1001;
            const tch = tripleDigit(&ring[ri]);
            Md5.hash(numStr.bytes(), &ring[ri], .{});
            numStr.inc();
            ringIndex += 1;
            if (tch == null) {
                continue;
            }
            const ch = tch.?;
            for (1..1001) |i| {
                if (hasFive(&ring[(ti + i) % 1001], ch)) {
                    if (n == 64) {
                        p1 = ti;
                        break :loop;
                    }
                    n += 1;
                    break;
                }
            }
        }
    }
    var p2: usize = 0;
    {
        std.mem.copyForwards(u8, &b, inp);
        var numStr = try aoc.NumStr.init(aoc.halloc, &b, inp.len - 1);
        for (0..1001) |i| {
            Md5.hash(numStr.bytes(), &ring[i], .{});
            var h: [32]u8 = undefined;
            for (0..2016) |_| {
                for (0..16) |j| {
                    h[j * 2] = CHR[ring[i][j] >> 4];
                    h[1 + j * 2] = CHR[ring[i][j] & 0xf];
                }
                Md5.hash(&h, &ring[i], .{});
            }
            numStr.inc();
        }
        var ringIndex: usize = 0;
        var n: usize = 1;
        loop: while (true) {
            const ti = ringIndex;
            const ri = ti % 1001;
            const tch = tripleDigit(&ring[ri]);
            Md5.hash(numStr.bytes(), &ring[ri], .{});
            var h: [32]u8 = undefined;
            for (0..2016) |_| {
                for (0..16) |j| {
                    h[j * 2] = CHR[ring[ri][j] >> 4];
                    h[1 + j * 2] = CHR[ring[ri][j] & 0xf];
                }
                Md5.hash(&h, &ring[ri], .{});
            }
            numStr.inc();
            ringIndex += 1;
            if (tch == null) {
                continue;
            }
            const ch = tch.?;
            for (1..1001) |i| {
                if (hasFive(&ring[(ti + i) % 1001], ch)) {
                    if (n == 64) {
                        p2 = ti;
                        break :loop;
                    }
                    n += 1;
                    break;
                }
            }
        }
    }
    return [2]usize{ p1, p2 };
}

fn tripleDigit(h: *[16]u8) ?u8 {
    for (0..16 - 1) |i| {
        if ((h[i] >> 4) == (h[i] & 0xf) and (h[i] >> 4) == (h[i + 1] >> 4)) {
            return h[i] >> 4;
        }
        if ((h[i] & 0xf) == (h[i + 1] >> 4) and (h[i] & 0xf) == (h[i + 1] & 0xf)) {
            return h[i] & 0xf;
        }
    }
    return null;
}

fn hasFive(h: *[16]u8, d: u8) bool {
    const d0 = d << 4;
    const dd = d | d0;
    for (0..16 - 2) |i| {
        if (h[i + 1] != dd) {
            continue;
        }
        if (h[i] == dd and h[i + 2] & 0xf0 == d0) {
            return true;
        }
        if (h[i] & 0xf == d and h[i + 2] == dd) {
            return true;
        }
    }
    return false;
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
