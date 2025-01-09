const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Comp = enum {
    Gt,
    Lt,
    Ge,
    Le,
    Eq,
    Ne,
};

const Inst = struct {
    out: usize,
    in: usize,
    inc: i32,
    op: i32,
    comp: Comp,
};

fn parts(inp: []const u8) anyerror![2]usize {
    var s = try std.BoundedArray(Inst, 1024).init(0);
    var ids = try std.BoundedArray(usize, 30).init(0);
    var seen: [19683]bool = .{false} ** 19683;
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        const out = try aoc.chompWord(usize, aoc.AlphaLowerWord, inp, &i);
        const mul: i32 = if (inp[i + 1] == 'i') 1 else -1;
        i += 5;
        const inc = mul * try aoc.chompInt(i32, inp, &i);
        i += 4;
        const in = try aoc.chompWord(usize, aoc.AlphaLowerWord, inp, &i);
        i += 1;
        var comp: Comp = undefined;
        switch (inp[i]) {
            '=' => {
                comp = Comp.Eq;
                i += 3;
            },
            '!' => {
                comp = Comp.Ne;
                i += 3;
            },
            '>' => {
                if (inp[i + 1] == '=') {
                    comp = Comp.Ge;
                    i += 3;
                } else {
                    comp = Comp.Gt;
                    i += 2;
                }
            },
            '<' => {
                if (inp[i + 1] == '=') {
                    comp = Comp.Le;
                    i += 3;
                } else {
                    comp = Comp.Lt;
                    i += 2;
                }
            },
            else => unreachable,
        }
        const op = try aoc.chompInt(i32, inp, &i);
        try s.append(Inst{ .out = out, .in = in, .inc = inc, .op = op, .comp = comp });
        if (!seen[out]) {
            try ids.append(out);
            seen[out] = true;
        }
    }
    const prog = s.slice();
    var reg: [19683]i32 = .{0} ** 19683;
    var p2: i32 = 0;
    for (prog) |inst| {
        const cmp = switch (inst.comp) {
            Comp.Eq => reg[inst.in] == inst.op,
            Comp.Ne => reg[inst.in] != inst.op,
            Comp.Gt => reg[inst.in] > inst.op,
            Comp.Ge => reg[inst.in] >= inst.op,
            Comp.Lt => reg[inst.in] < inst.op,
            Comp.Le => reg[inst.in] <= inst.op,
        };
        if (cmp) {
            reg[inst.out] += inst.inc;
            if (p2 < reg[inst.out]) {
                p2 = reg[inst.out];
            }
        }
    }
    var p1: i32 = 0;
    for (ids.slice()) |id| {
        if (p1 < reg[id]) {
            p1 = reg[id];
        }
    }
    return [2]usize{ @as(usize, @intCast(p1)), @as(usize, @intCast(p2)) };
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
