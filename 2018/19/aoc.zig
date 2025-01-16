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
    var reg: [NUM_REG]Int = .{0} ** NUM_REG;
    {
        var ip: usize = 0;
        while (ip < prog.len) {
            const inst = prog[ip];
            reg[rip] = @intCast(ip);
            if (inst.do(&reg, rip)) |newIP| {
                ip = @intCast(newIP);
            }
            ip += 1;
            if (ip == 2) {
                break;
            }
        }
    }
    var p1: usize = 0;
    {
        const m = reg[4];
        var n: u32 = 1;
        while (n <= m) : (n += 1) {
            p1 += n * @intFromBool(@rem(m, n) == 0);
        }
    }
    reg = .{0} ** NUM_REG;
    reg[0] = 1;
    {
        var ip: usize = 0;
        while (ip < prog.len) {
            const inst = prog[ip];
            reg[rip] = @intCast(ip);
            if (inst.do(&reg, rip)) |newIP| {
                ip = @intCast(newIP);
            }
            ip += 1;
            if (ip == 2) {
                break;
            }
        }
    }
    var p2: usize = 0;
    {
        const m = reg[4];
        var n: u32 = 1;
        while (n <= m) : (n += 1) {
            p2 += n * @intFromBool(@rem(m, n) == 0);
        }
    }
    return [2]usize{ p1, p2 };
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
