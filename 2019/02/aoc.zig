const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Int = i32;

fn parts(inp: []const u8) anyerror![2]usize {
    var it = aoc.uintIter(Int, inp);
    var s = try std.BoundedArray(Int, 2048).init(0);
    while (it.next()) |a| {
        try s.append(a);
    }
    var prog = s.slice();

    const p1 = run(prog[0..], 12, 2);

    var p2: ?usize = null;
    var n: Int = 0;
    while (n < 100) : (n += 1) {
        const r = run(prog[0..], n, 0);
        if (r > 19690720) {
            break;
        }
    }
    n -= 1;
    var v: Int = 0;
    while (v < 100) : (v += 1) {
        const r = run(prog[0..], n, v);
        if (r == 19690720) {
            p2 = @intCast(n * 100 + v);
            break;
        }
    }
    return [2]usize{ @intCast(p1), p2.? };
}

fn run(in: []Int, n: Int, v: Int) Int {
    var pc: usize = 0;
    var prog: [2048]Int = undefined;
    std.mem.copyForwards(Int, &prog, in);
    prog[1] = n;
    prog[2] = v;
    while (true) : (pc += 4) {
        switch (prog[pc]) {
            99 => break,
            1 => prog[@as(usize, @intCast(prog[pc + 3]))] =
                prog[@as(usize, @intCast(prog[pc + 1]))] +
                prog[@as(usize, @intCast(prog[pc + 2]))],
            2 => prog[@as(usize, @intCast(prog[pc + 3]))] =
                prog[@as(usize, @intCast(prog[pc + 1]))] *
                prog[@as(usize, @intCast(prog[pc + 2]))],
            else => unreachable,
        }
    }
    return prog[0];
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
