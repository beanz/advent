const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

const pascal = generatePascal();

fn generatePascal() [22][22]isize {
    var p: [22][22]isize = std.mem.zeroes([22][22]isize);
    p[0][0] = 1;
    p[1][0] = 1;
    p[1][1] = 1;
    for (2..22) |r| {
        p[r][0] = 1;
        for (1..r) |c| {
            p[r][c] = p[r - 1][c - 1] + p[r - 1][c];
        }
        p[r][r] = 1;
    }
    return p;
}

test "testcases" {
    try aoc.TestCases(isize, parts);
}

fn parts(inp: []const u8) anyerror![2]isize {
    var p1: isize = 0;
    var p2: isize = 0;
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        var l = try std.BoundedArray(isize, 21).init(0);
        while (true) : (i += 1) {
            const n = try aoc.chompInt(isize, inp, &i);
            try l.append(n);
            if (inp[i] == '\n') {
                break;
            }
        }
        const s = solve(pascal[l.len][0 .. l.len + 1], l.slice());
        p1 += s[0];
        p2 += s[1];
    }
    return [2]isize{ p1, p2 };
}

fn solve(p: []const isize, nums: []isize) [2]isize {
    var m: isize = 1;
    var s1: isize = 0;
    var s2: isize = 0;
    for (0..nums.len) |i| {
        const tm = p[i + 1] * m;
        s1 += tm * nums[nums.len - 1 - i];
        s2 += tm * nums[i];
        m *= -1;
    }
    return [2]isize{ s1, s2 };
}

test "solve" {
    var t = [_]isize{ 0, 3, 6, 9, 12, 15 };
    try aoc.assertEq([2]isize{ 18, -3 }, solve(pascal[6][0..7], &t));
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
