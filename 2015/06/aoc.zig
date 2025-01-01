const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Op = enum {
    On,
    Off,
    Toggle,
};

fn parts(inp: []const u8) anyerror![2]usize {
    var i: usize = 0;
    var m: [1_000_000]bool = .{false} ** 1_000_000;
    var m2: [1_000_000]u16 = .{0} ** 1_000_000;
    while (i < inp.len) : (i += 1) {
        var op: Op = undefined;
        switch (inp[i + 6]) {
            ' ' => { // toggle
                i += 7;
                op = Op.Toggle;
            },
            'f' => { // off
                i += 9;
                op = Op.Off;
            },
            else => { // on
                i += 8;
                op = Op.On;
            },
        }
        const x1 = try aoc.chompUint(usize, inp, &i);
        i += 1;
        const y1 = try aoc.chompUint(usize, inp, &i);
        i += 9;
        const x2 = try aoc.chompUint(usize, inp, &i);
        i += 1;
        const y2 = try aoc.chompUint(usize, inp, &i);
        switch (op) {
            Op.On => {
                for (y1..y2 + 1) |y| {
                    for (x1..x2 + 1) |x| {
                        m[x + 1000 * y] = true;
                        m2[x + 1000 * y] += 1;
                    }
                }
            },
            Op.Off => {
                for (y1..y2 + 1) |y| {
                    for (x1..x2 + 1) |x| {
                        m[x + 1000 * y] = false;
                        if (m2[x + 1000 * y] != 0) {
                            m2[x + 1000 * y] -= 1;
                        }
                    }
                }
            },
            Op.Toggle => {
                for (y1..y2 + 1) |y| {
                    for (x1..x2 + 1) |x| {
                        m[x + 1000 * y] = !m[x + 1000 * y];
                        m2[x + 1000 * y] += 2;
                    }
                }
            },
        }
    }
    var p1: usize = 0;
    var p2: usize = 0;
    for (0..1_000_000) |j| {
        p1 += @intFromBool(m[j]);
        p2 += m2[j];
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
