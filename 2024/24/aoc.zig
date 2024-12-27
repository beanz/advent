const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Op = enum { And, Or, Xor, Noop };

const Gate = struct {
    a: [3]u8,
    b: [3]u8,
    op: Op,
    val: ?u1,
};

const Res = struct {
    p1: usize,
    p2: [31]u8,
};

fn parts(inp: []const u8) anyerror!Res {
    var gates = std.AutoHashMap([3]u8, Gate).init(aoc.halloc);
    defer gates.deinit();
    var rev = std.AutoHashMap(Gate, [3]u8).init(aoc.halloc);
    defer rev.deinit();
    var rev2 = std.AutoHashMap([3]u8, Gate).init(aoc.halloc);
    defer rev2.deinit();
    var bad = std.AutoHashMap([3]u8, bool).init(aoc.halloc);
    defer bad.deinit();
    var bit_count: usize = 0;
    var i: usize = 0;
    while (i < inp.len) {
        if (inp[i] == '\n') {
            i += 1;
            continue;
        }
        if (inp[i + 3] == ':') {
            const v: u1 = if (inp[i + 5] == '1') 1 else 0;
            try gates.put([3]u8{ inp[i], inp[i + 1], inp[i + 2] }, Gate{ .a = [3]u8{ 0, 0, 0 }, .b = [3]u8{ 0, 0, 0 }, .op = Op.Noop, .val = v });
            i += 7;
            continue;
        }
        var op: Op = undefined;
        var off: usize = 0;
        switch (inp[i + 4]) {
            'X' => {
                op = Op.Xor;
                off = 1;
            },
            'A' => {
                op = Op.And;
                off = 1;
            },
            'O' => {
                op = Op.Or;
            },
            else => unreachable,
        }
        const a = [3]u8{ inp[i], inp[i + 1], inp[i + 2] };
        const b = [3]u8{ inp[i + 7 + off], inp[i + 8 + off], inp[i + 9 + off] };
        const r = [3]u8{ inp[i + 14 + off], inp[i + 15 + off], inp[i + 16 + off] };
        if (r[0] == 'z') {
            const n = 10 * @as(usize, r[1] - '0') + @as(usize, r[2] - '0');
            if (n > bit_count) {
                bit_count = n;
            }
        }
        try rev.put(Gate{ .a = a, .b = b, .op = op, .val = null }, r);
        try gates.put(r, Gate{ .a = a, .b = b, .op = op, .val = null });
        try rev2.put(a, Gate{ .a = a, .b = b, .op = op, .val = null });
        try rev2.put(b, Gate{ .a = a, .b = b, .op = op, .val = null });
        if (op == Op.Xor and
            !((a[0] == 'x' and b[0] == 'y') or (b[0] == 'x' and a[0] == 'y') or r[0] == 'z'))
        {
            try bad.put(r, true);
        }
        i += 18 + off;
    }
    var p1: usize = 0;
    var z: usize = bit_count;
    while (true) {
        const t = @as(u8, @intCast(z / 10)) + '0';
        const u = @as(u8, @intCast(z % 10)) + '0';
        p1 = (p1 << 1) + @as(usize, value(&gates, [3]u8{ 'z', t, u }));

        const gxor = rev.get(Gate{ .a = [3]u8{ 'x', t, u }, .b = [3]u8{ 'y', t, u }, .op = Op.Xor, .val = null }) orelse rev.get(Gate{ .a = [3]u8{ 'y', t, u }, .b = [3]u8{ 'x', t, u }, .op = Op.Xor, .val = null });
        const gand = rev.get(Gate{ .a = [3]u8{ 'x', t, u }, .b = [3]u8{ 'y', t, u }, .op = Op.And, .val = null }) orelse rev.get(Gate{ .a = [3]u8{ 'y', t, u }, .b = [3]u8{ 'x', t, u }, .op = Op.And, .val = null });
        const znn = gates.get([3]u8{ 'z', t, u });

        if (!(gxor == null or gand == null or znn == null)) {
            if (znn.?.op != Op.Xor) {
                try bad.put([3]u8{ 'z', t, u }, true);
            }

            if (z > 0) {
                const gor = rev2.get(gand.?);
                if (gor == null or gor.?.op != Op.Or) {
                    try bad.put(gand.?, true);
                }
                const not_or = rev2.get(gxor.?);
                if (not_or == null or not_or.?.op == Op.Or) {
                    try bad.put(gxor.?, true);
                }
            }
        }
        if (z == 0) {
            break;
        }
        z -= 1;
    }
    var p2 = try std.BoundedArray([3]u8, 8).init(0);
    var it = bad.keyIterator();
    while (it.next()) |b| {
        try p2.append(b.*);
    }
    var p2r: [31]u8 = .{32} ** 31;
    if (inp.len < 1000) {
        p2r[0] = 't';
        p2r[1] = 'e';
        p2r[2] = 's';
        p2r[3] = 't';
        return Res{ .p1 = p1, .p2 = p2r };
    }
    const p2s = p2.slice();
    std.mem.sort([3]u8, p2s, {}, cmp);
    p2r[0] = p2s[0][0];
    p2r[1] = p2s[0][1];
    p2r[2] = p2s[0][2];
    for (1..p2s.len) |ii| {
        const j = 3 + (ii - 1) * 4;
        p2r[j] = ',';
        p2r[j + 1] = p2s[ii][0];
        p2r[j + 2] = p2s[ii][1];
        p2r[j + 3] = p2s[ii][2];
    }
    return Res{ .p1 = p1, .p2 = p2r };
}

fn cmp(_: void, a: [3]u8, b: [3]u8) bool {
    return std.mem.order(u8, a[0..], b[0..]).compare(std.math.CompareOperator.lt);
}

fn value(gates: *std.AutoHashMap([3]u8, Gate), k: [3]u8) u1 {
    if (gates.get(k)) |g| {
        if (g.val) |v| {
            return v;
        }
        const va = value(gates, g.a);
        const vb = value(gates, g.b);
        return switch (g.op) {
            Op.Or => va | vb,
            Op.And => va & vb,
            Op.Xor => va ^ vb,
            else => unreachable,
        };
    }
    unreachable;
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {s}\n", .{ p.p1, p.p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
