const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCasesRes(Res, parts);
}

const Res = struct {
    p1: usize,
    p2: [8]u8,
};

const Int = i64;
const Arity: [10]usize = [10]usize{ 0, 3, 3, 1, 1, 2, 2, 3, 3, 1 };

const P1 = struct {
    m: *std.AutoHashMap([2]i8, u1),
    x: i8,
    y: i8,
    dx: i8,
    dy: i8,
    v: []u1,
    i: usize,
    first: bool,
    fn init(m: *std.AutoHashMap([2]i8, u1), v: []u1) P1 {
        return P1{
            .m = m,
            .v = v,
            .x = 0,
            .y = 0,
            .dx = 0,
            .dy = -1,
            .i = 0,
            .first = true,
        };
    }
    fn count(self: P1) usize {
        return self.m.count();
    }
    fn iter(self: *P1) anyerror!void {
        var col: u1 = undefined;
        var turn: u1 = undefined;
        if (self.first) {
            col = 1;
            turn = 0;
            self.first = false;
        } else {
            const input = self.m.get([2]i8{ self.x, self.y }) orelse 0;
            col = 1 - input;
            self.i += 1;
            if (self.i == self.v.len) {
                self.i = 0;
            }
            turn = @intFromBool(self.v[self.i] == input);
            self.v[self.i] = input;
        }
        //aoc.print("col: {} turn: {}\n", .{ col, turn });
        try self.m.put([2]i8{ self.x, self.y }, col);
        if (turn == 1) {
            const t = self.dx;
            self.dx = -self.dy;
            self.dy = t;
        } else {
            const t = -self.dx;
            self.dx = self.dy;
            self.dy = t;
        }
        self.x += self.dx;
        self.y += self.dy;
        //aoc.print(" p({},{})\n", .{ self.x, self.y });
    }
};

fn parts(inp: []const u8) anyerror!Res {
    var p: [2048]Int = undefined;
    var l: usize = 0;
    {
        var i: usize = 0;
        while (i < inp.len) : (i += 1) {
            p[l] = try aoc.chompInt(Int, inp, &i);
            l += 1;
        }
    }
    const prog = p[0..l];
    var p1: usize = 0;
    {
        var i: usize = 0;
        var n: usize = 0;
        var v: [10]u1 = .{0} ** 10;
        v[0] = 1;
        var vi: usize = 1;
        while (i < prog.len) : (i += 1) {
            const op = @rem(prog[i], 100);
            if (op < 0 or op >= Arity.len) {
                continue;
            }
            if (prog[i] == 1007 and prog[i + 1] == 9 and prog[i + 3] == 10) {
                n = @intCast(prog[i + 2]);
            }
            if (op == 8 and prog[i + 3] == 10 and vi <= 9) {
                //aoc.print("{}\n", .{i});
                v[vi] = @intCast(if (prog[i + 1] == 8) prog[i + 2] else prog[i + 1]);
                vi += 1;
            }
            i += Arity[@intCast(op)];
        }
        //aoc.print("{} {any}\n", .{ n, v });
        var m = std.AutoHashMap([2]i8, u1).init(aoc.halloc);
        var r = P1.init(&m, v[0..]);
        for (0..n * 10 + 1) |_| {
            try r.iter();
        }
        p1 = r.count();
    }

    const p2Addr = @as(usize, @intCast(prog[4]));
    var p2: [8]u8 = .{32} ** 8;
    {
        var data: [6]u64 = .{0} ** 6;
        for (&[6]usize{ 6, 17, 64, 75, 98, 109 }, 0..) |o, i| {
            const addr = p2Addr + o;
            data[i] = @as(u64, @intCast(switch (prog[addr]) {
                21101 => prog[addr + 1] + prog[addr + 2],
                21102 => prog[addr + 1] * prog[addr + 2],
                else => unreachable,
            }));
        }
        var screen: [252]u1 = undefined;
        plot(0, 0, 1, data[0], screen[0..]); // left-to-right zig-zag
        plot(20, 0, 1, data[1], screen[0..]);
        plot(41, 3, -1, data[2], screen[0..]); // right-to-left zig-zag
        plot(21, 3, -1, data[3], screen[0..]);
        plot(0, 4, 1, data[4], screen[0..]); // left-to-right zig-zag
        plot(20, 4, 1, data[5], screen[0..]);
        for (0..8) |i| {
            var v: u64 = 0;
            for (0..6) |j| {
                for (0..5) |k| {
                    v = (v << 1) + @as(u64, @intCast(screen[42 * j + 5 * i + k + 1]));
                }
            }
            p2[i] = aoc.ocr(v);
        }
    }

    return Res{ .p1 = p1, .p2 = p2 };
}

fn plot(ix: Int, iy: Int, d: Int, data: usize, screen: []u1) void {
    var x = ix;
    var y = iy;
    var bit = @as(usize, 1) << 39;
    while (bit != 0) {
        x = x + d;
        screen[@as(usize, @intCast(y * 42 + x))] = @intFromBool(data & bit != 0);
        bit >>= 1;
        y = y + d;
        screen[@as(usize, @intCast(y * 42 + x))] = @intFromBool(data & bit != 0);
        bit >>= 1;
        x = x + d;
        screen[@as(usize, @intCast(y * 42 + x))] = @intFromBool(data & bit != 0);
        bit >>= 1;
        y = y - d;
        screen[@as(usize, @intCast(y * 42 + x))] = @intFromBool(data & bit != 0);
        bit >>= 1;
    }
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
