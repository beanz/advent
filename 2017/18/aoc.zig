const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Reg = u8;
const Value = isize;

const RegValue = struct {
    reg: Reg,
    value: Value,
};

const RegReg = struct {
    reg: Reg,
    reg2: Reg,
};

const Inst = union(enum) {
    addLit: RegValue,
    addReg: RegReg,
    modLit: RegValue,
    modReg: RegReg,
    mulLit: RegValue,
    mulReg: RegReg,
    setLit: RegValue,
    setReg: RegReg,
    jgzLit: RegValue,
    jgzReg: RegReg,
    jmp: Value,
    rcv: Reg,
    snd: Reg,
};

fn parts(inp: []const u8) anyerror![2]usize {
    var i: usize = 0;
    for (0..8) |_| {
        while (inp[i] != '\n') : (i += 1) {}
        i += 1;
    }
    i += 6;
    const n = try aoc.chompUint(usize, inp, &i);
    i += 7;
    var p = try aoc.chompUint(usize, inp, &i);
    var v: [127]usize = .{0} ** 127;
    for (0..n) |ii| {
        p *= 8505;
        p %= 0x7fffffff;
        p *= 129749;
        p += 12345;
        p %= 0x7fffffff;
        v[ii] = p % 10000;
    }
    const p1 = v[n - 1];
    var c: usize = 1;
    var swap = true;
    while (swap) {
        c += 1;
        swap = false;
        for (1..n) |ii| {
            if (v[ii - 1] < v[ii]) {
                swap = true;
                std.mem.swap(usize, &v[ii], &v[ii - 1]);
            }
        }
    }
    return [2]usize{ p1, c * n / 2 };
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
