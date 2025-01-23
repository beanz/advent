const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const PROG_CAP: usize = 4096;
const WIDTH_ADDR: usize = 49;
const HEIGHT_ADDR: usize = 60;
const REMAINING_BLOCKS_ADDR: usize = 387;
const INST_A_ADDR: usize = 611;
const INST_B_ADDR: usize = 615;
const MAP_ADDR: usize = 639;

const Int = i64;
const Arity: [10]usize = [10]usize{ 0, 3, 3, 1, 1, 2, 2, 3, 3, 1 };

fn parts(inp: []const u8) anyerror![2]usize {
    var p: [PROG_CAP]Int = undefined;
    var l: usize = 0;
    {
        var i: usize = 0;
        while (i < inp.len) : (i += 1) {
            p[l] = try aoc.chompInt(Int, inp, &i);
            l += 1;
        }
    }
    const prog = p[0..l];
    const p1: usize = @intCast(prog[REMAINING_BLOCKS_ADDR]);
    const a: usize = @intCast(switch (prog[INST_A_ADDR]) {
        21101 => prog[INST_A_ADDR + 1] + prog[INST_A_ADDR + 2],
        21102 => prog[INST_A_ADDR + 1] * prog[INST_A_ADDR + 2],
        else => unreachable,
    });
    const b: usize = @intCast(switch (prog[INST_B_ADDR]) {
        21101 => prog[INST_B_ADDR + 1] + prog[INST_B_ADDR + 2],
        21102 => prog[INST_B_ADDR + 1] * prog[INST_B_ADDR + 2],
        else => unreachable,
    });
    const w: usize = @intCast(prog[WIDTH_ADDR]);
    const h: usize = @intCast(prog[HEIGHT_ADDR]);
    l = w * h;
    const scoreTableAddr = MAP_ADDR + l;
    var p2: usize = 0;
    for (0..h) |y| {
        for (0..w) |x| {
            if (prog[MAP_ADDR + y * w + x] == 2) {
                const addr = scoreTableAddr + ((x * h + y) * a + b) % l;
                p2 += @intCast(prog[addr]);
            }
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
