const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const NUM_REG = 6;
const Int = usize;

fn parts(inp: []const u8) anyerror![2]usize {
    var s = try std.BoundedArray(Inst, 1280).init(0);
    var rip: usize = undefined;
    {
        var i: usize = 4;
        rip = try aoc.chompUint(usize, inp, &i);
        i += 1;
        while (i < inp.len) : (i += 1) {
            const op: Op = switch (inp[i]) {
                'a' => if (inp[i + 3] == 'r') Op.addr else Op.addi,
                'm' => if (inp[i + 3] == 'r') Op.mulr else Op.muli,
                'b' => if (inp[i + 1] == 'a')
                    (if (inp[i + 3] == 'r') Op.banr else Op.bani)
                else
                    (if (inp[i + 3] == 'r') Op.borr else Op.bori),
                's' => if (inp[i + 3] == 'r') Op.setr else Op.seti,
                'g' => if (inp[i + 2] == 'i') Op.gtir else (if (inp[i + 3] == 'i') Op.gtri else Op.gtrr),
                'e' => if (inp[i + 2] == 'i') Op.eqir else (if (inp[i + 3] == 'i') Op.eqri else Op.eqrr),
                else => unreachable,
            };
            i += 5;
            const opA = try aoc.chompUint(Int, inp, &i);
            i += 1;
            const opB = try aoc.chompUint(Int, inp, &i);
            i += 1;
            const opC = try aoc.chompUint(Int, inp, &i);
            try s.append(Inst{ .op = op, .a = opA, .b = opB, .c = opC });
        }
    }
    const prog = s.slice();
    const mask = prog[10].b;
    const a = prog[7].a;
    const b = prog[11].b;
    const bxb = (b * b) & mask;
    const bxbxb = (bxb * b) & mask;
    var last_reg5: Int = 0;
    var reg5: Int = 0;
    var p1: Int = 0;
    var seen = std.AutoHashMap(usize, bool).init(aoc.halloc);
    try seen.ensureTotalCapacity(16384);
    defer seen.deinit();
    while (true) {
        last_reg5 = reg5;
        reg5 = (((reg5 >> 16) | 1) * b + ((reg5 >> 8) & 255) * bxb + ((reg5 & 255) + a) * bxbxb) & mask;
        if (seen.count() == 0) {
            p1 = reg5;
        }
        if (seen.get(reg5)) |_| {
            break;
        }
        try seen.put(reg5, true);
    }

    return [2]usize{ p1, last_reg5 };
}

const Op = enum(u4) {
    addr,
    addi,
    mulr,
    muli,
    banr,
    bani,
    borr,
    bori,
    setr,
    seti,
    gtir,
    gtri,
    gtrr,
    eqir,
    eqri,
    eqrr,
};

const Inst = struct {
    op: Op,
    a: Int,
    b: Int,
    c: Int,

    fn do(self: Inst, reg: []Int, rip: usize) ?usize {
        const out = @as(usize, self.c);
        const ua = @as(usize, self.a);
        const ub = @as(usize, self.b);
        reg[out] = switch (self.op) {
            Op.addr => reg[ua] + reg[ub],
            Op.addi => reg[ua] + self.b,
            Op.mulr => reg[ua] * reg[ub],
            Op.muli => reg[ua] * self.b,
            Op.banr => reg[ua] & reg[ub],
            Op.bani => reg[ua] & self.b,
            Op.borr => reg[ua] | reg[ub],
            Op.bori => reg[ua] | self.b,
            Op.setr => reg[ua],
            Op.seti => self.a,
            Op.gtir => @intFromBool(self.a > reg[ub]),
            Op.gtri => @intFromBool(reg[ua] > self.b),
            Op.gtrr => @intFromBool(reg[ua] > reg[ub]),
            Op.eqir => @intFromBool(self.a == reg[ub]),
            Op.eqri => @intFromBool(reg[ua] == self.b),
            Op.eqrr => @intFromBool(reg[ua] == reg[ub]),
        };
        return if (out == rip) @intCast(reg[out]) else null;
    }
};

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
