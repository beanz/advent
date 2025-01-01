const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Op = enum { And, Or, Lshift, Rshift, Not, AndLiteral, Literal, Noop };

const Gate = struct {
    a: u16,
    b: u16,
    op: Op,
    cache: [2]?u16,
};

fn parts(inp: []const u8) anyerror![2]usize {
    var g = std.AutoHashMap(u16, Gate).init(aoc.halloc);
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        switch (inp[i]) {
            'a'...'z' => {
                var a: u16 = @intCast(inp[i] - '`');
                i += 1;
                if (inp[i] != ' ') {
                    a = (a << 5) + @as(u16, inp[i] - '`');
                    i += 1;
                }
                i += 1;
                var gate = Gate{ .a = a, .b = undefined, .op = undefined, .cache = .{ null, null } };
                switch (inp[i]) {
                    'A' => {
                        gate.op = Op.And;
                        i += 4;
                        var b: u16 = @intCast(inp[i] - '`');
                        i += 1;
                        if (inp[i] != ' ') {
                            b = (b << 5) + @as(u16, inp[i] - '`');
                            i += 1;
                        }
                        i += 4;
                        gate.b = b;
                    },
                    'O' => {
                        gate.op = Op.Or;
                        i += 3;
                        var b: u16 = @intCast(inp[i] - '`');
                        i += 1;
                        if (inp[i] != ' ') {
                            b = (b << 5) + @as(u16, inp[i] - '`');
                            i += 1;
                        }
                        i += 4;
                        gate.b = b;
                    },
                    'L' => {
                        gate.op = Op.Lshift;
                        i += 7;
                        const b: u16 = try aoc.chompUint(u16, inp, &i);
                        i += 4;
                        gate.b = b;
                    },
                    'R' => {
                        gate.op = Op.Rshift;
                        i += 7;
                        const b: u16 = try aoc.chompUint(u16, inp, &i);
                        i += 4;
                        gate.b = b;
                    },
                    '-' => {
                        gate.op = Op.Noop;
                        gate.b = 0;
                        i += 3;
                    },
                    else => unreachable,
                }
                var r: u16 = @intCast(inp[i] - '`');
                i += 1;
                if (inp[i] != '\n') {
                    r = (r << 5) + @as(u16, inp[i] - '`');
                    i += 1;
                }
                try g.put(r, gate);
            },
            '0'...'9' => {
                const a: u16 = try aoc.chompUint(u16, inp, &i);
                i += 1;
                switch (inp[i]) {
                    '-' => {
                        i += 3;
                        var r: u16 = @intCast(inp[i] - '`');
                        i += 1;
                        if (inp[i] != '\n') {
                            r = (r << 5) + @as(u16, inp[i] - '`');
                            i += 1;
                        }
                        try g.put(r, Gate{ .a = a, .b = 0, .op = Op.Literal, .cache = .{ null, null } });
                    },
                    'A' => {
                        i += 4;
                        var b: u16 = @intCast(inp[i] - '`');
                        i += 1;
                        if (inp[i] != ' ') {
                            b = (b << 5) + @as(u16, inp[i] - '`');
                            i += 1;
                        }
                        i += 4;
                        var r: u16 = @intCast(inp[i] - '`');
                        i += 1;
                        if (inp[i] != '\n') {
                            r = (r << 5) + @as(u16, inp[i] - '`');
                            i += 1;
                        }
                        try g.put(r, Gate{ .a = a, .b = b, .op = Op.AndLiteral, .cache = .{ null, null } });
                    },
                    else => unreachable,
                }
            },
            'N' => {
                i += 4;
                var a: u16 = @intCast(inp[i] - '`');
                i += 1;
                if (inp[i] != ' ') {
                    a = (a << 5) + @as(u16, inp[i] - '`');
                    i += 1;
                }
                i += 4;
                var r: u16 = @intCast(inp[i] - '`');
                i += 1;
                if (inp[i] != '\n') {
                    r = (r << 5) + @as(u16, inp[i] - '`');
                    i += 1;
                }
                try g.put(r, Gate{ .a = a, .b = 0, .op = Op.Not, .cache = .{ null, null } });
            },
            else => unreachable,
        }
    }
    const p1 = value(&g, @as(u16, 'a' - '`'), 0);
    var gate = g.getPtr(@as(u16, 'b' - '`')) orelse unreachable;
    gate.cache[1] = p1;
    const p2 = value(&g, @as(u16, 'a' - '`'), 1);
    return [2]usize{ p1, p2 };
}

fn value(g: *std.AutoHashMap(u16, Gate), r: u16, part: usize) u16 {
    var gate = g.getPtr(r) orelse unreachable;
    if (gate.cache[part]) |v| {
        return v;
    }
    const res = switch (gate.op) {
        Op.And => value(g, gate.a, part) & value(g, gate.b, part),
        Op.Or => value(g, gate.a, part) | value(g, gate.b, part),
        Op.Lshift => value(g, gate.a, part) << @as(u4, @truncate(gate.b)),
        Op.Rshift => value(g, gate.a, part) >> @as(u4, @truncate(gate.b)),
        Op.Not => value(g, gate.a, part) ^ 0xffff,
        Op.AndLiteral => gate.a & value(g, gate.b, part),
        Op.Literal => return gate.a,
        Op.Noop => value(g, gate.a, part),
    };
    gate.cache[part] = res;
    return res;
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
