const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Int = i32;
const Arity: [10]usize = [10]usize{ 0, 3, 3, 1, 1, 2, 2, 3, 3, 1 };

fn parts(inp: []const u8) anyerror![2]usize {
    var p: [1024]Int = undefined;
    var l: usize = 0;
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        p[l] = try aoc.chompInt(Int, inp, &i);
        l += 1;
    }
    const prog = p[0..l];
    var p1: usize = 0;
    i = 0;
    while (i < prog.len) {
        const op = @rem(prog[i], 100);
        if (0 <= op and op < Arity.len) {
            const arity: usize = Arity[@intCast(op)];
            if ((prog[i] == 1002 and prog[i + 1] == 64 and prog[i + 2] == 2 and prog[i + 3] == 64) or (prog[i] == 4 and prog[i + 1] == 64)) {
                p1 <<= 1;
                p1 += @intFromBool((prog[i - 4] == 1001 and prog[i - 7] != i) or prog[i - 9] == 1001);
            }
            i += arity;
        }
        i += 1;
    }
    // 21305 is 26th element of https://oeis.org/A097333
    const p2 = prog[917] + 21305;
    return [2]usize{ @intCast(p1), @intCast(p2) };
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
