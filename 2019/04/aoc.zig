const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Int = u32;

const Rec = struct {
    n: Int,
    p2: Int,
};

const table = init: {
    var s: [4794]Rec = undefined;
    var n100000 = '0';
    var n10000 = '0';
    var n1000 = '0';
    var n100 = '0';
    var n10 = '0';
    var n1 = '0';
    const e100000 = '9';
    const e10000 = '9';
    const e1000 = '9';
    const e100 = '9';
    const e10 = '9';
    const e1 = '9';
    var l: usize = 0;
    var n: Int = 0;
    @setEvalBranchQuota(1000000);
    while (n100000 != e100000 or n10000 != e10000 or n1000 != e1000 or n100 != e100 or n10 != e10 or n1 != e1) {
        if (n10 <= n1 and n100 <= n10 and n1000 <= n100 and n10000 <= n1000 and n100000 <= n10000 and (n100000 == n10000 or n10000 == n1000 or n1000 == n100 or n100 == n10 or n10 == n1)) {
            s[l] = Rec{ .n = n, .p2 = @intFromBool((n100000 == n10000 and n10000 != n1000) or (n10000 == n1000 and n1000 != n100 and n10000 != n100000) or (n1000 == n100 and n100 != n10 and n1000 != n10000) or (n100 == n10 and n10 != n1 and n100 != n1000) or (n10 == n1 and n10 != n100)) };
            l += 1;
        }
        n += 1;
        if (n1 != '9') {
            n1 += 1;
            continue;
        }
        n1 = '0';
        if (n10 != '9') {
            n10 += 1;
            continue;
        }
        n10 = '0';
        if (n100 != '9') {
            n100 += 1;
            continue;
        }
        n100 = '0';
        if (n1000 != '9') {
            n1000 += 1;
            continue;
        }
        n1000 = '0';
        if (n10000 != '9') {
            n10000 += 1;
            continue;
        }
        n10000 = '0';
        n100000 += 1;
    }
    break :init s;
};

fn parts(inp: []const u8) anyerror![2]usize {
    const b = @as(usize, @intCast(inp[0] & 0xf)) * 100000 + @as(usize, @intCast(inp[1] & 0xf)) * 10000 + @as(usize, @intCast(inp[2] & 0xf)) * 1000 + @as(usize, @intCast(inp[3] & 0xf)) * 100 + @as(usize, @intCast(inp[4] & 0xf)) * 10 + @as(usize, @intCast(inp[5] & 0xf));
    const e = @as(usize, @intCast(inp[7] & 0xf)) * 100000 + @as(usize, @intCast(inp[8] & 0xf)) * 10000 + @as(usize, @intCast(inp[9] & 0xf)) * 1000 + @as(usize, @intCast(inp[10] & 0xf)) * 100 + @as(usize, @intCast(inp[11] & 0xf)) * 10 + @as(usize, @intCast(inp[12] & 0xf));
    var p1: usize = 0;
    var p2: usize = 0;
    for (table) |r| {
        if (b <= r.n and r.n <= e) {
            p1 += 1;
            p2 += r.p2;
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
