const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "examples" {
    var t1 = try parts(aoc.test1file);
    try aoc.assertEq(@as(i32, 114), t1[0]);
    try aoc.assertEq(@as(i32, 2), t1[1]);
    var p = try parts(aoc.inputfile);
    try aoc.assertEq(@as(i32, 1584748274), p[0]);
    try aoc.assertEq(@as(i32, 1026), p[1]);
}

fn parts(inp: []const u8) ![2]i32 {
    var p1: i32 = 0;
    var p2: i32 = 0;
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        var l = try std.BoundedArray(i32, 21).init(0);
        while (true) : (i += 1) {
            var n = try aoc.chompInt(i32, inp, &i);
            try l.append(n);
            if (inp[i] == '\n') {
                break;
            }
        }
        var lb = try std.BoundedArray(i32, 21).init(0);
        var l1 = l.slice();
        for (0..l1.len) |j| {
            try lb.append(l1[l.len - 1 - j]);
        }
        p1 += solve(l1);
        var l2 = lb.slice();
        p2 += solve(l2);
    }
    return [2]i32{ p1, p2 };
}

fn solve(l: []i32) i32 {
    var len = l.len;
    var f = l[len - 1];
    while (true) {
        var done = true;
        for (0..len - 1) |i| {
            var d = l[i + 1] - l[i];
            if (d != 0) {
                done = false;
            }
            l[i] = d;
        }
        if (done) {
            return f;
        }
        len -= 1;
        f += l[len - 1];
    }
}

test "solve" {
    var t = [_]i32{ 0, 3, 6, 9, 12, 15 };
    try aoc.assertEq(@as(i32, 18), solve(&t));
    var t2 = [_]i32{ 15, 12, 9, 6, 3, 0 };
    try aoc.assertEq(@as(i32, -3), solve(&t2));
}

fn run(steps: []const u8, ml: [26426]u16, mr: [26426]u16, start: u16) u64 {
    var c: u64 = 0;
    var p = start;
    while (true) {
        if (steps[c % steps.len] == 'L') {
            p = ml[p];
        } else {
            p = mr[p];
        }
        if (p == 0) {
            return 1;
        }
        p -= 1;
        c += 1;
        if ((p & 0x1f) == 25) {
            return c;
        }
    }
}

fn readID(inp: []const u8, i: usize) u16 {
    return (@as(u16, inp[i] - 'A') << 10) + (@as(u16, inp[i + 1] - 'A') << 5) + @as(u16, inp[i + 2] - 'A');
}

fn lcm(a: u64, b: u64) u64 {
    return (a * b) / gcd(a, b);
}

fn gcd(pa: u64, pb: u64) u64 {
    var a = pa;
    var b = pb;
    if (a > b) {
        var t = a;
        a = b;
        b = t;
    }
    while (a != 0) {
        var na = b % a;
        b = a;
        a = na;
    }
    return b;
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    var p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
