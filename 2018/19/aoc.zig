const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const NUM_REG = 6;
const Int = u32;

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
    //aoc.print("{any}\n", .{prog[21]});
    //aoc.print("{any}\n", .{prog[23]});
    const t1 = 4 * 19 * 11 + prog[21].b * 22 + prog[23].b;
    const p1 = sumfact(Int, t1);
    const t2 = t1 + (27 * 28 + 29) * 30 * 14 * 32;
    const p2 = sumfact(Int, t2);
    return [2]usize{ p1, p2 };
}

inline fn sumfact(comptime T: type, n: T) T {
    var s: T = 0;
    var m: T = 1;
    while (m <= n) : (m += 1) {
        s += m * @intFromBool(@rem(n, m) == 0);
    }
    return s;
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
