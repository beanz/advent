const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Int = u8;
const Tree = [63]?Int;

fn chompTree(inp: []const u8, i: *usize) Tree {
    var t: Tree = .{null} ** 63;
    var j: usize = 0;
    while (i.* <= inp.len) : (i.* += 1) {
        switch (inp[i.*]) {
            '\n' => break,
            '[' => j = 2 * j + 1,
            ']' => j = (j - 1) / 2,
            ',' => j += 1,
            '0'...'9' => |ch| t[j] = (ch & 0xf),
            else => unreachable,
        }
    }
    return t;
}

fn pretty(a: Tree) void {
    prettySub(a, 0);
    aoc.print("\n", .{});
}

fn prettySub(a: Tree, i: usize) void {
    if (a[i]) |x| {
        aoc.print("{}", .{x});
        return;
    }
    aoc.print("[", .{});
    prettySub(a, 2 * i + 1);
    aoc.print(",", .{});
    prettySub(a, 2 * i + 2);
    aoc.print("]", .{});
}

fn add(a: *Tree, b: *const Tree) Tree {
    var t: Tree = .{null} ** 63;
    std.mem.copyForwards(?Int, t[3..5], a[1..3]);
    std.mem.copyForwards(?Int, t[7..11], a[3..7]);
    std.mem.copyForwards(?Int, t[15..23], a[7..15]);
    std.mem.copyForwards(?Int, t[31..47], a[15..31]);
    std.mem.copyForwards(?Int, t[5..7], b[1..3]);
    std.mem.copyForwards(?Int, t[11..15], b[3..7]);
    std.mem.copyForwards(?Int, t[23..31], b[7..15]);
    std.mem.copyForwards(?Int, t[47..63], b[15..31]);
    var i: usize = 31;
    while (i < 63) : (i += 2) {
        if (t[i]) |_| {
            explode(&t, i);
        }
    }
    while (split(&t)) {}
    return t;
}

fn explode(t: *Tree, i: usize) void {
    if (i > 31) {
        var j = i - 1;
        while (true) {
            if (t[j]) |x| {
                t[j] = x + t[i].?;
                break;
            }
            j = (j - 1) / 2;
        }
    }
    if (i < 61) {
        var j = i + 2;
        while (true) {
            if (t[j]) |x| {
                t[j] = x + t[i + 1].?;
                break;
            }
            j = (j - 1) / 2;
        }
    }
    t[i] = null;
    t[i + 1] = null;
    t[(i - 1) / 2] = 0;
}

fn split(t: *Tree) bool {
    for (&[30]usize{
        1, 3, 7, 15, 16, 8, 17, 18, 4, 9, 19, 20, 10, 21, 22, 2, 5, 11, 23, 24, 12, 25, 26, 6, 13, 27, 28, 14, 29, 30,
    }) |i| {
        if (t[i]) |x| {
            if (x >= 10) {
                t[2 * i + 1] = x / 2;
                t[2 * i + 2] = (x + 1) / 2;
                t[i] = null;
                if (i >= 15) {
                    explode(t, 2 * i + 1);
                }
                return true;
            }
        }
    }
    return false;
}

fn magnitude(sf: *const Tree, i: usize) usize {
    if (sf[i]) |x| {
        return @intCast(x);
    }
    return 3 * @as(usize, @intCast(magnitude(sf, 2 * i + 1))) + 2 * @as(usize, @intCast(magnitude(sf, 2 * i + 2)));
}

fn parts(inp: []const u8) anyerror![2]usize {
    const sf = parse: {
        var sf: [100]Tree = undefined;
        var l: usize = 0;
        var i: usize = 0;
        while (i < inp.len) : (i += 1) {
            sf[l] = chompTree(inp, &i);
            l += 1;
        }
        break :parse sf[0..l];
    };
    var p1 = sf[0];
    for (sf[1..]) |a| {
        p1 = add(&p1, &a);
    }
    var p2: usize = 0;
    for (0..sf.len) |i| {
        for (0..sf.len) |j| {
            if (i == j) {
                continue;
            }
            const t = add(&sf[i], &sf[j]);
            const m = magnitude(&t, 0);
            if (m > p2) {
                p2 = m;
            }
        }
    }
    return [2]usize{ magnitude(&p1, 0), p2 };
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
