const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Rec = struct {
    m: usize,
    a: usize,
};

fn parts(inp: []const u8) anyerror![2]usize {
    var i: usize = 12;
    const a = try aoc.chompUint(usize, inp, &i);
    i += 39;
    const prog = inp[i .. inp.len - 1];
    const p1 = run(prog, a);
    var target: usize = 0;
    while (i < inp.len) : (i += 2) {
        target = (10 * target) + @as(usize, inp[i] - '0');
    }
    const target_m = try std.math.powi(usize, 10, (prog.len + 1) / 2);
    var back: [1024]Rec = undefined;
    var work = aoc.Deque(Rec).init(back[0..]);
    try work.push(Rec{ .m = 1, .a = 0 });
    var p2: usize = 0;
    LOOP: while (work.pop()) |cur| {
        for (0..8) |c| {
            const v = c + 8 * cur.a;
            const got = run(prog, v);
            if ((got % cur.m) == (target % cur.m)) {
                if (cur.m == target_m) {
                    p2 = v;
                    break :LOOP;
                }
                try work.push(Rec{ .m = cur.m * 10, .a = v });
            }
        }
    }
    return [2]usize{ p1, p2 };
}

fn run(prog: []const u8, ai: usize) usize {
    if (prog.len != 31) {
        return runSlow(prog, ai);
    }
    var a = ai;
    const x = @as(usize, prog[6] - '0');
    const y = @as(usize, prog[(if (prog[12] == '1') 14 else 18)] - '0');
    var out: usize = 0;
    var b: usize = 0;
    var c: usize = 0;
    while (a > 0) {
        b = a & 7;
        b ^= x;
        const b6: u6 = @intCast(b);
        c = a >> b6;
        b ^= y;
        b ^= c;
        a >>= 3;
        out = (10 * out) + (b & 7);
    }
    return out;
}

fn runSlow(prog: []const u8, ai: usize) usize {
    var out: usize = 0;
    var a: usize = ai;
    var b: usize = 0;
    var c: usize = 0;
    var i: usize = 0;
    while (i < prog.len - 2) {
        const op = prog[i] - '0';
        const literal: usize = @intCast(prog[i + 2] - '0');
        const combo = switch (literal) {
            0...3 => literal,
            4 => a,
            5 => b,
            6 => c,
            else => unreachable,
        };
        switch (op) {
            0 => {
                const s: u6 = @intCast(combo);
                a >>= s;
            },
            1 => b ^= literal,
            2 => b = combo & 7,
            3 => if (a != 0) {
                i = literal * 2;
                continue;
            },
            4 => b ^= c,
            5 => out = (10 * out) + (combo & 7),
            6 => {
                const s: u6 = @intCast(combo);
                b = a >> s;
            },
            else => {
                const s: u6 = @intCast(combo);
                c = a >> s;
            },
        }
        i += 4;
    }
    return out;
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        var p1: [32]u8 = .{44} ** 32;
        var j: usize = 31;
        var p1n = p[0];
        while (j >= 0 and p1n > 0) : (j -= 2) {
            p1[j] = @intCast(p1n % 10);
            p1[j] += '0';
            p1n /= 10;
        }
        aoc.print("Part1: {s}\nPart2: {}\n", .{ p1[j + 2 ..], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
