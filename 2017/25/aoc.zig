const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Rec = struct {
    state: u8,
    v: [2]bool,
    m: [2]bool,
    n: [2]u8,
};

fn parts(inp: []const u8) anyerror![2]usize {
    const start = inp[15] - 'A';
    var i: usize = 54;
    const steps = try aoc.chompUint(usize, inp, &i);
    var s = try std.BoundedArray(Rec, 8).init(0);
    i += 9;
    while (i < inp.len) : (i += 1) {
        const state = inp[i + 9] - 'A';
        i += 12;
        const v0 = inp[i + 51] == '1';
        const m0 = inp[i + 81] == 'r';
        if (m0) {
            i += 1;
        }
        const n0 = inp[i + 113] - 'A';
        i += 116;
        const v1 = inp[i + 51] == '1';
        const m1 = inp[i + 81] == 'r';
        if (m1) {
            i += 1;
        }
        const n1 = inp[i + 113] - 'A';
        i += 116;
        try s.append(Rec{
            .state = state,
            .m = .{ m0, m1 },
            .v = .{ v0, v1 },
            .n = .{ n0, n1 },
        });
    }
    const states = s.slice();
    var tape: [20000]bool = .{false} ** 20000;
    var cur: usize = 8000;
    var state = start;
    for (0..steps) |_| {
        const v = @as(usize, @intFromBool(tape[cur]));
        tape[cur] = states[state].v[v];
        cur -= 1;
        cur += 2 * @as(usize, @intFromBool(states[state].m[v]));
        state = states[state].n[v];
    }
    var p1: usize = 0;
    for (tape) |v| {
        p1 += @as(usize, @intFromBool(v));
    }
    return [2]usize{ p1, 0 };
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
