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
    var p1: Int = 0;
    var v1: Int = 0;
    var p2: Int = 0;
    var v2: ?Int = null;
    i = 0;
    while (i < prog.len) {
        const op = @rem(prog[i], 100);
        if (0 <= op and op < Arity.len) {
            const arity: usize = Arity[@intCast(op)];
            if (op == 1) {
                if (prog[i + 1] == 224 and prog[i + 2] != 223) {
                    v1 = prog[i + 2];
                } else if (prog[i + 2] == 224 and prog[i + 1] != 223) {
                    v1 = prog[i + 1];
                } else if ((prog[i + 1] == 223 and prog[i + 2] == 224) or
                    (prog[i + 2] == 223 and prog[i + 1] == 224))
                {
                    p1 = (p1 << 3) + v1;
                    //aoc.print("V1: {}\n", .{v1});
                }
            }
            if (op == 7 or op == 8) {
                v2 = p2code(prog[i], prog[i + 1], prog[i + 2]);
            }
            if (v2) |v| {
                if (op == 5) {
                    p2 <<= 1;
                    p2 += @intFromBool(v == 0);
                    //aoc.print("P2: {}\n", .{@intFromBool(v == 0)});
                } else if (op == 6) {
                    p2 <<= 1;
                    p2 += @intFromBool(v != 0);
                    //aoc.print("P2: {}\n", .{@intFromBool(v != 0)});
                }
            }
            i += arity;
        }
        i += 1;
    }
    return [2]usize{ @intCast(p1), @intCast(p2) };
}

fn p2code(op: Int, a: Int, b: Int) ?Int {
    if (a != 226 and a != 677) {
        return null;
    }
    if (b != 226 and b != 677) {
        return null;
    }
    return switch (op) {
        7 => if (a == 677 and b == 226) 1 else 0,
        107 => if (a == 226 and b == 226) 1 else 0,
        1007 => if (a == 677 and b == 677) 1 else 0,
        1107 => if (a == 226 and b == 677) 1 else 0,
        8, 1108 => if ((a == 226 and b == 226) or (a == 677 and b == 677)) 1 else 0,
        108, 1008 => if ((a == 226 and b == 226) or (a == 677 and b == 677)) 0 else 1,
        else => unreachable,
    };
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
