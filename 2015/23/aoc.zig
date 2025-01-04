const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Op = enum { Hlf, Tpl, Inc, Jmp, Jie, Jio };

const Inst = struct {
    op: Op,
    reg: usize,
    offset: isize,
};

fn parts(inp: []const u8) anyerror![2]usize {
    var is = try std.BoundedArray(Inst, 64).init(0);
    var i: usize = 0;
    while (i < inp.len) {
        switch (inp[i]) {
            'h' => {
                try is.append(Inst{ .op = Op.Hlf, .reg = @as(usize, inp[i + 4] - 'a'), .offset = 0 });
                i += 6;
            },
            't' => {
                try is.append(Inst{ .op = Op.Tpl, .reg = @as(usize, inp[i + 4] - 'a'), .offset = 0 });
                i += 6;
            },
            'i' => {
                try is.append(Inst{ .op = Op.Inc, .reg = @as(usize, inp[i + 4] - 'a'), .offset = 0 });
                i += 6;
            },
            'j' => {
                if (inp[i + 1] == 'm') {
                    i += 4;
                    const o = try aoc.chompInt(isize, inp, &i);
                    try is.append(Inst{ .op = Op.Jmp, .reg = 0, .offset = o });
                    i += 1;
                } else if (inp[i + 2] == 'e') {
                    const r = @as(usize, inp[i + 4] - 'a');
                    i += 7;
                    const o = try aoc.chompInt(isize, inp, &i);
                    try is.append(Inst{ .op = Op.Jie, .reg = r, .offset = o });
                    i += 1;
                } else {
                    const r = @as(usize, inp[i + 4] - 'a');
                    i += 7;
                    const o = try aoc.chompInt(isize, inp, &i);
                    try is.append(Inst{ .op = Op.Jio, .reg = r, .offset = o });
                    i += 1;
                }
            },
            else => unreachable,
        }
    }
    const prog = is.slice();
    var reg: [2]usize = .{ 0, 0 };
    var ip: usize = 0;
    while (ip < prog.len) {
        const inst = prog[ip];
        switch (inst.op) {
            Op.Hlf => reg[inst.reg] >>= 1,
            Op.Tpl => reg[inst.reg] *= 3,
            Op.Inc => reg[inst.reg] += 1,
            Op.Jmp => {
                ip = @as(usize, @intCast(@as(isize, @intCast(ip)) + inst.offset));
                continue;
            },
            Op.Jie => if (reg[inst.reg] & 1 == 0) {
                ip = @as(usize, @intCast(@as(isize, @intCast(ip)) + inst.offset));
                continue;
            },
            Op.Jio => if (reg[inst.reg] == 1) {
                ip = @as(usize, @intCast(@as(isize, @intCast(ip)) + inst.offset));
                continue;
            },
        }
        ip += 1;
    }
    const p1 = reg[1];
    reg = .{ 1, 0 };
    ip = 0;
    while (ip < prog.len) {
        const inst = prog[ip];
        switch (inst.op) {
            Op.Hlf => reg[inst.reg] >>= 1,
            Op.Tpl => reg[inst.reg] *= 3,
            Op.Inc => reg[inst.reg] += 1,
            Op.Jmp => {
                ip = @as(usize, @intCast(@as(isize, @intCast(ip)) + inst.offset));
                continue;
            },
            Op.Jie => if (reg[inst.reg] & 1 == 0) {
                ip = @as(usize, @intCast(@as(isize, @intCast(ip)) + inst.offset));
                continue;
            },
            Op.Jio => if (reg[inst.reg] == 1) {
                ip = @as(usize, @intCast(@as(isize, @intCast(ip)) + inst.offset));
                continue;
            },
        }
        ip += 1;
    }
    return [2]usize{ p1, reg[1] };
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
