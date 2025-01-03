const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var m: [102]u128 = .{0} ** 102;
    var m2: [102]u128 = .{0} ** 102;
    var l: usize = 1;
    {
        var b: u128 = 2;
        for (inp) |ch| {
            switch (ch) {
                '\n' => {
                    b = 2;
                    l += 1;
                    continue;
                },
                '#' => {
                    m[l] |= b;
                    m2[l] |= b;
                },
                else => {},
            }
            b <<= 1;
        }
    }
    const h = l - 1;
    const w = (inp.len / h) - 1;
    const bw = @as(u128, 1) << @as(u7, @intCast(w));
    var p1: usize = 0;
    {
        const steps: usize = if (h < 10) 4 else 100;
        var n: [102]u128 = .{0} ** 102;
        for (0..steps) |_| {
            for (1..h + 1) |y| {
                var b: u128 = 2;
                for (1..w + 1) |_| {
                    const b1 = b << 1;
                    const b2 = b >> 1;
                    const count: usize = get(m, b1, y) + get(m, b2, y) +
                        get(m, b1, y - 1) + get(m, b, y - 1) + get(m, b2, y - 1) +
                        get(m, b1, y + 1) + get(m, b, y + 1) + get(m, b2, y + 1);
                    if (count == 3 or (count == 2 and m[y] & b != 0)) {
                        n[y] |= b;
                    }
                    b <<= 1;
                }
            }
            aoc.swap([102]u128, &m, &n);
            for (1..h + 1) |y| {
                n[y] = 0;
            }
        }
        for (1..h + 1) |y| {
            p1 += @popCount(m[y]);
        }
    }
    var p2: usize = 0;
    m2[1] |= 2 | bw;
    m2[h] |= 2 | bw;
    {
        const steps: usize = if (h < 10) 5 else 100;
        var n: [102]u128 = .{0} ** 102;
        for (0..steps) |_| {
            for (1..h + 1) |y| {
                var b: u128 = 2;
                for (1..w + 1) |_| {
                    const b1 = b << 1;
                    const b2 = b >> 1;
                    const count: usize = get(m2, b1, y) + get(m2, b2, y) +
                        get(m2, b1, y - 1) + get(m2, b, y - 1) + get(m2, b2, y - 1) +
                        get(m2, b1, y + 1) + get(m2, b, y + 1) + get(m2, b2, y + 1);
                    if (count == 3 or (count == 2 and m2[y] & b != 0)) {
                        n[y] |= b;
                    }
                    b <<= 1;
                }
            }
            aoc.swap([102]u128, &m2, &n);
            m2[1] |= 2 | bw;
            m2[h] |= 2 | bw;
            for (1..h + 1) |y| {
                n[y] = 0;
            }
        }
        for (1..h + 1) |y| {
            p2 += @popCount(m2[y]);
        }
    }
    return [2]usize{ p1, p2 };
}

fn get(m: [102]u128, bx: u128, y: usize) usize {
    return @as(usize, @intFromBool(m[y] & bx != 0));
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
