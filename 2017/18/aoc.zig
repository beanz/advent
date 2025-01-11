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
    var s = try std.BoundedArray(Inst, 64).init(0);
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        const r = inp[i + 4];
        switch (inp[i]) {
            'a' => {
                i += 6;
                if (inp[i] < 'a') {
                    const v = try aoc.chompInt(Value, inp, &i);
                    try s.append(Inst{ .addLit = RegValue{ .reg = r & 0x1f, .value = v } });
                } else {
                    const r2 = inp[i] & 0x1f;
                    i += 1;
                    try s.append(Inst{ .addReg = RegReg{ .reg = r & 0x1f, .reg2 = r2 } });
                }
            },
            'j' => {
                i += 6;
                if (inp[i] < 'a') {
                    const v = try aoc.chompInt(Value, inp, &i);
                    if (r < 'a') {
                        try s.append(Inst{ .jmp = v });
                    } else {
                        try s.append(Inst{ .jgzLit = RegValue{ .reg = r & 0x1f, .value = v } });
                    }
                } else {
                    const r2 = inp[i] & 0x1f;
                    i += 1;
                    try s.append(Inst{ .jgzReg = RegReg{ .reg = r & 0x1f, .reg2 = r2 } });
                }
            },
            'm' => {
                if (inp[i + 1] == 'o') {
                    i += 6;
                    if (inp[i] < 'a') {
                        const v = try aoc.chompInt(Value, inp, &i);
                        try s.append(Inst{ .modLit = RegValue{ .reg = r & 0x1f, .value = v } });
                    } else {
                        const r2 = inp[i] & 0x1f;
                        i += 1;
                        try s.append(Inst{ .modReg = RegReg{ .reg = r & 0x1f, .reg2 = r2 } });
                    }
                } else {
                    i += 6;
                    if (inp[i] < 'a') {
                        const v = try aoc.chompInt(Value, inp, &i);
                        try s.append(Inst{ .mulLit = RegValue{ .reg = r & 0x1f, .value = v } });
                    } else {
                        const r2 = inp[i] & 0x1f;
                        i += 1;
                        try s.append(Inst{ .mulReg = RegReg{ .reg = r & 0x1f, .reg2 = r2 } });
                    }
                }
            },
            'r' => {
                try s.append(Inst{ .rcv = r & 0x1f });
                i += 5;
            },
            's' => {
                if (inp[i + 1] == 'e') {
                    i += 6;
                    if (inp[i] < 'a') {
                        const v = try aoc.chompInt(Value, inp, &i);
                        try s.append(Inst{ .setLit = RegValue{ .reg = r & 0x1f, .value = v } });
                    } else {
                        const r2 = inp[i] & 0x1f;
                        i += 1;
                        try s.append(Inst{ .setReg = RegReg{ .reg = r & 0x1f, .reg2 = r2 } });
                    }
                } else {
                    try s.append(Inst{ .snd = r & 0x1f });
                    i += 5;
                }
            },
            else => unreachable,
        }
    }
    const prog = s.slice();
    var ip: usize = 0;
    var reg: [27]Value = .{0} ** 27;
    var snd: usize = 0;
    var p1: usize = 0;
    while (ip < prog.len) {
        const inst = prog[ip];
        switch (inst) {
            .addLit => |a| {
                reg[a.reg] += a.value;
            },
            .addReg => |a| {
                reg[a.reg] += reg[a.reg2];
            },
            .modLit => |a| {
                reg[a.reg] = @mod(reg[a.reg], a.value);
            },
            .modReg => |a| {
                reg[a.reg] = @mod(reg[a.reg], reg[a.reg2]);
            },
            .mulLit => |a| {
                reg[a.reg] *= a.value;
            },
            .mulReg => |a| {
                reg[a.reg] *= reg[a.reg2];
            },
            .setLit => |a| {
                reg[a.reg] = a.value;
            },
            .setReg => |a| {
                reg[a.reg] = reg[a.reg2];
            },
            .jgzLit => |a| {
                if (reg[a.reg] > 0) {
                    ip = @as(usize, @intCast(@as(Value, @intCast(ip)) + a.value));
                    continue;
                }
            },
            .jgzReg => |a| {
                if (reg[a.reg] > 0) {
                    ip = @as(usize, @intCast(@as(Value, @intCast(ip)) + a.reg2));
                    continue;
                }
            },
            .jmp => |v| {
                ip = @as(usize, @intCast(@as(Value, @intCast(ip)) + v));
            },
            .snd => |r| {
                snd = @as(usize, @intCast(reg[r]));
            },
            .rcv => |r| {
                if (reg[r] != 0) {
                    p1 = snd;
                    break;
                }
            },
        }
        ip += 1;
    }
    return [2]usize{ snd, 999 };
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
