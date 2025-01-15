const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCasesRes(Res, parts);
}

const Res = struct {
    p1: [11]u8,
    p2: [11]u8,
};

const SIZE = 300;
const CACHE_TYPE = i32;

fn parts(inp: []const u8) anyerror!Res {
    var i: usize = 0;
    const serial = try aoc.chompUint(CACHE_TYPE, inp, &i);
    var cache: [SIZE * SIZE]CACHE_TYPE = undefined;
    {
        for (0..SIZE) |y| {
            for (0..SIZE) |x| {
                var l = level(x + 1, y + 1, serial);
                if (x > 0) {
                    l += cache[(x - 1) + SIZE * y];
                    if (y > 0) {
                        l -= cache[(x - 1) + SIZE * (y - 1)];
                    }
                }
                if (y > 0) {
                    l += cache[x + SIZE * (y - 1)];
                }
                cache[x + SIZE * y] = l;
            }
        }
    }

    var p1x: usize = 0;
    var p1y: usize = 0;
    {
        var max: CACHE_TYPE = std.math.minInt(CACHE_TYPE);
        // 2 comes from size-1 = 3-1
        for (0..SIZE - 2) |x| {
            for (0..SIZE - 2) |y| {
                const l = level_square(&cache, x, y, 3);
                if (l > max) {
                    max = l;
                    p1x = x + 1;
                    p1y = y + 1;
                }
            }
        }
    }
    var p2x: usize = 0;
    var p2y: usize = 0;
    var p2s: usize = 0;
    {
        var max: CACHE_TYPE = std.math.minInt(CACHE_TYPE);
        for (1..31) |size| {
            for (0..SIZE - size + 1) |x| {
                for (0..SIZE - size + 1) |y| {
                    const l = level_square(&cache, x, y, size);
                    if (l > max) {
                        max = l;
                        p2x = x + 1;
                        p2y = y + 1;
                        p2s = size;
                    }
                }
            }
        }
    }

    var res = Res{
        .p1 = .{32} ** 11,
        .p2 = .{32} ** 11,
    };
    {
        const l = std.fmt.formatIntBuf(&res.p1, p1x, 10, std.fmt.Case.lower, .{});
        res.p1[l] = ',';
        _ = std.fmt.formatIntBuf(res.p1[l + 1 ..], p1y, 10, std.fmt.Case.lower, .{});
    }
    {
        var l = std.fmt.formatIntBuf(&res.p2, p2x, 10, std.fmt.Case.lower, .{});
        res.p2[l] = ',';
        l += 1 + std.fmt.formatIntBuf(res.p2[l + 1 ..], p2y, 10, std.fmt.Case.lower, .{});
        res.p2[l] = ',';
        _ = std.fmt.formatIntBuf(res.p2[l + 1 ..], p2s, 10, std.fmt.Case.lower, .{});
    }
    return res;
}

inline fn level_square(cache: []CACHE_TYPE, x: usize, y: usize, size: usize) CACHE_TYPE {
    const ux = x + size - 1;
    const uy = y + size - 1;
    var s = cache[ux + SIZE * uy];
    if (x > 0) {
        s -= cache[(x - 1) + SIZE * uy];
        if (y > 0) {
            s += cache[(x - 1) + SIZE * (y - 1)];
        }
    }
    if (y > 1) {
        s -= cache[ux + SIZE * (y - 1)];
    }
    return s;
}

inline fn level(x: usize, y: usize, serial: CACHE_TYPE) CACHE_TYPE {
    const r = @as(CACHE_TYPE, @intCast(x)) + 10;
    var p = r * @as(CACHE_TYPE, @intCast(y));
    p += serial;
    p *= r;
    p = @divTrunc(p, 100);
    p = @mod(p, 10);
    return p - 5;
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {s}\nPart2: {s}\n", .{ p.p1, p.p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
